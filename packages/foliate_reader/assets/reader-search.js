import { Overlayer } from './foliate-js/overlayer.js';

const foldText = text => text.normalize('NFD').replace(/\p{M}/gu, '');
const pauseSearch = () => new Promise(resolve => setTimeout(resolve, 0));
const maxCachedText = 8 * 1024 * 1024;
const maxCachedDocumentText = 2 * 1024 * 1024;

export class ReaderBookSearch {
    #view;
    #book = null;
    #generation = 0;
    #texts = new Map();
    #textSize = 0;
    #documents = new Map();
    #documentSize = 0;
    #pending = new Map();
    #highlight = null;
    #highlightTimer = null;

    constructor(view) {
        this.#view = view;
    }

    cancel() {
        this.#generation++;
    }

    clearHighlight() {
        clearTimeout(this.#highlightTimer);
        this.#highlightTimer = null;
        if (this.#highlight) {
            this.#highlight.overlayer.remove(this.#highlight.key);
            this.#highlight = null;
        }
    }

    highlight(cfi) {
        this.clearHighlight();

        const { index, anchor } = this.#view.resolveCFI(cfi);
        const item = this.#view.renderer?.getContents?.().find(item => item.index === index);
        if (!item?.overlayer || !item.doc) {
            return;
        }

        const key = 'foliate-search:yaabsa-selected-result';
        item.overlayer.add(key, anchor(item.doc), Overlayer.highlight, { color: '#FFCA28' });
        this.#highlight = { key, overlayer: item.overlayer };
        this.#highlightTimer = setTimeout(() => this.clearHighlight(), 3000);
    }

    reset(book = null) {
        this.cancel();
        this.clearHighlight();
        this.#book = book;
        this.#texts.clear();
        this.#textSize = 0;
        this.#documents.clear();
        this.#documentSize = 0;
        this.#pending.clear();
    }

    #remember(index, data) {
        if (data.folded.length <= maxCachedText) {
            const previous = this.#texts.get(index);
            if (previous !== undefined) {
                this.#textSize -= previous.length;
                this.#texts.delete(index);
            }
            while (this.#textSize + data.folded.length > maxCachedText) {
                const oldest = this.#texts.keys().next().value;
                this.#textSize -= this.#texts.get(oldest).length;
                this.#texts.delete(oldest);
            }
            this.#texts.set(index, data.folded);
            this.#textSize += data.folded.length;
        }

        const size = data.original.length + data.folded.length;
        if (size > maxCachedDocumentText) {
            return;
        }

        while (this.#documents.size >= 4 || this.#documentSize + size > maxCachedDocumentText) {
            const oldest = this.#documents.keys().next().value;
            const previous = this.#documents.get(oldest);
            this.#documentSize -= previous.original.length + previous.folded.length;
            this.#documents.delete(oldest);
        }
        this.#documents.set(index, data);
        this.#documentSize += size;
    }

    async #indexSection(book, index) {
        const doc = await book.sections[index].createDocument();
        if (!doc?.body || book !== this.#book) {
            return null;
        }

        const walker = doc.createTreeWalker(doc.body, NodeFilter.SHOW_ELEMENT | NodeFilter.SHOW_TEXT | NodeFilter.SHOW_CDATA_SECTION, {
            acceptNode(node) {
                if (node.nodeType === Node.ELEMENT_NODE) {
                    return ['script', 'style'].includes(node.localName?.toLowerCase())
                        ? NodeFilter.FILTER_REJECT : NodeFilter.FILTER_SKIP;
                }
                return NodeFilter.FILTER_ACCEPT;
            },
        });
        const nodes = [];
        const original = [];
        const folded = [];
        let originalOffset = 0;
        let foldedOffset = 0;
        let lastPause = performance.now();

        for (let node = walker.nextNode(); node; node = walker.nextNode()) {
            const text = node.nodeValue || '';
            const normalized = foldText(text);
            if (normalized.length > 0) {
                nodes.push({ node, originalOffset, foldedOffset, end: foldedOffset + normalized.length, unchanged: normalized === text });
            }
            original.push(text);
            folded.push(normalized);
            originalOffset += text.length;
            foldedOffset += normalized.length;

            if (performance.now() - lastPause >= 8) {
                await pauseSearch();
                if (book !== this.#book) {
                    return null;
                }
                lastPause = performance.now();
            }
        }

        const data = { doc, nodes, original: original.join(''), folded: folded.join('') };
        this.#remember(index, data);
        return data;
    }

    async #loadSection(book, index) {
        const cached = this.#documents.get(index);
        if (cached) {
            this.#documents.delete(index);
            this.#documents.set(index, cached);
            return cached;
        }

        if (this.#pending.has(index)) {
            return this.#pending.get(index);
        }

        const pending = this.#indexSection(book, index);
        this.#pending.set(index, pending);
        try {
            return await pending;
        } finally {
            if (this.#pending.get(index) === pending) {
                this.#pending.delete(index);
            }
        }
    }

    #findNode(nodes, offset) {
        let low = 0;
        let high = nodes.length - 1;
        while (low < high) {
            const middle = Math.floor((low + high) / 2);
            if (nodes[middle].end <= offset) {
                low = middle + 1;
            } else {
                high = middle;
            }
        }
        return nodes[low];
    }

    #sourceOffsets(entry) {
        if (entry.offsets) {
            return entry.offsets;
        }

        const starts = [];
        const ends = [];
        let offset = 0;
        for (const character of entry.node.nodeValue) {
            const normalized = foldText(character);
            for (let index = 0; index < normalized.length; index++) {
                starts.push(offset);
                ends.push(offset + character.length);
            }
            offset += character.length;
            if (normalized.length === 0 && ends.length > 0) {
                ends[ends.length - 1] = offset;
            }
        }
        entry.offsets = { starts, ends };
        return entry.offsets;
    }

    #makeResult(index, data, match) {
        const startNode = this.#findNode(data.nodes, match.index);
        const endOffset = match.index + match[0].length;
        const endNode = this.#findNode(data.nodes, endOffset - 1);
        const relativeStart = match.index - startNode.foldedOffset;
        const relativeEnd = endOffset - endNode.foldedOffset;
        const start = startNode.unchanged ? relativeStart : this.#sourceOffsets(startNode).starts[relativeStart];
        const end = endNode.unchanged ? relativeEnd : this.#sourceOffsets(endNode).ends[relativeEnd - 1];
        const range = data.doc.createRange();
        range.setStart(startNode.node, start);
        range.setEnd(endNode.node, end);

        const excerptStart = Math.max(0, startNode.originalOffset + start - 55);
        const excerptEnd = Math.min(data.original.length, endNode.originalOffset + end + 85);
        const excerpt = data.original.slice(excerptStart, excerptEnd).replace(/\s+/gu, ' ').trim();
        return { cfi: this.#view.getCFI(index, range), excerpt };
    }

    async search(query, limit = 300) {
        const book = this.#view.book;
        if (book !== this.#book) {
            this.reset(book);
        }
        const generation = ++this.#generation;
        const words = foldText(query).trim().split(/\s+/u);
        if (!book || !words[0]) {
            return [];
        }

        const escaped = words.map(word => word.replace(/[.*+?^${}()|[\]\\]/g, '\\$&'));
        const pattern = new RegExp(escaped.join('\\s+'), 'giu');
        const results = [];
        const resultLimit = Math.max(1, Math.min(300, Math.floor(limit) || 300));
        let lastPause = performance.now();

        for (let index = 0; index < book.sections.length; index++) {
            if (performance.now() - lastPause >= 8) {
                await pauseSearch();
                lastPause = performance.now();
            }
            if (generation !== this.#generation || book !== this.#view.book) {
                return null;
            }
            if (typeof book.sections[index].createDocument !== 'function') {
                continue;
            }

            pattern.lastIndex = 0;
            const cached = this.#texts.get(index);
            if (cached !== undefined && !pattern.test(cached)) {
                continue;
            }

            const data = await this.#loadSection(book, index);
            if (generation !== this.#generation || book !== this.#view.book) {
                return null;
            }
            if (!data) {
                continue;
            }

            pattern.lastIndex = 0;
            for (let match = pattern.exec(data.folded); match; match = pattern.exec(data.folded)) {
                results.push(this.#makeResult(index, data, match));
                if (results.length >= resultLimit) {
                    return results;
                }

                if (performance.now() - lastPause >= 8) {
                    await pauseSearch();
                    if (generation !== this.#generation || book !== this.#view.book) {
                        return null;
                    }
                    lastPause = performance.now();
                }
            }

        }
        return generation === this.#generation && book === this.#view.book ? results : null;
    }
}
