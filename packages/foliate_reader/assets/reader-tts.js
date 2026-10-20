const blockSelector = 'p,li,blockquote,h1,h2,h3,h4,h5,h6,dt,dd,td,th,figcaption,pre';
const excludedSelector = 'script,style,noscript,nav,[hidden],[aria-hidden="true"]';

export function collectSpeech(view, fromCurrent = true) {
    const contents = view.renderer?.getContents?.();
    const item = contents?.find(content => content.index === view.lastLocation?.section?.current) ?? contents?.[0];
    if (!item?.doc?.body) {
        return { sentences: [], ranges: [] };
    }

    return collectDocumentSpeech(view, item, fromCurrent ? view.lastLocation?.range : null);
}

function collectDocumentSpeech(view, item, start) {
    const doc = item.doc;
    const walker = doc.createTreeWalker(doc.body, NodeFilter.SHOW_TEXT, {
        acceptNode(node) {
            if (node.parentElement?.closest(excludedSelector)) {
                return NodeFilter.FILTER_REJECT;
            }

            const style = doc.defaultView?.getComputedStyle(node.parentElement) ?? node.parentElement.style;
            if (style?.display === 'none' || style?.visibility === 'hidden') {
                return NodeFilter.FILTER_REJECT;
            }

            return NodeFilter.FILTER_ACCEPT;
        },
    });
    let text = '';
    let previousBlock = null;
    const mappings = [];

    while (walker.nextNode()) {
        const node = walker.currentNode;
        let offset = 0;
        if (start) {
            if (node === start.startContainer) {
                offset = start.startOffset;
            } else {
                try {
                    if (start.comparePoint(node, node.length) < 0) {
                        continue;
                    }
                } catch (_) {
                    continue;
                }
            }
        }

        const value = node.textContent.slice(offset);
        if (!value) {
            continue;
        }

        const block = node.parentElement.closest(blockSelector);
        if (previousBlock && block !== previousBlock) {
            text += '\u2029';
        }
        previousBlock = block;
        const from = text.length;
        text += value;
        mappings.push({ from, to: text.length, node, offset });
    }

    const metadataLanguage = view.book.metadata?.language;
    const bookLanguage = Array.isArray(metadataLanguage) ? metadataLanguage[0] : metadataLanguage;
    const language = doc.documentElement.lang || bookLanguage || undefined;
    const segments = [];
    let segmenter;
    try {
        segmenter = new Intl.Segmenter(language, { granularity: 'sentence' });
    } catch (_) {}

    for (const paragraph of text.matchAll(/[^\u2029]+/g)) {
        const sentenceSegments = segmenter
            ? Array.from(segmenter.segment(paragraph[0]))
            : Array.from(paragraph[0].matchAll(/[^.!?]+(?:[.!?]+[\s]*|$)/g), match => ({ segment: match[0], index: match.index }));
        for (let index = 0; index < sentenceSegments.length; index++) {
            const sentence = sentenceSegments[index];
            segments.push({
                segment: sentence.segment,
                index: paragraph.index + sentence.index,
                breakAfter: index === sentenceSegments.length - 1,
            });
        }
    }

    const sentences = [];
    const ranges = [];

    for (const { segment, index, breakAfter } of segments) {
        const trimmed = segment.trim();
        if (!trimmed) {
            continue;
        }

        const from = index + segment.indexOf(trimmed);
        const to = from + trimmed.length;
        const first = mappings.find(mapping => mapping.to > from);
        const last = mappings.findLast(mapping => mapping.from < to);
        if (!first || !last) {
            continue;
        }

        const range = doc.createRange();
        range.setStart(first.node, first.offset + Math.max(0, from - first.from));
        range.setEnd(last.node, last.offset + Math.min(last.to, to) - last.from);
        sentences.push({
            text: trimmed.replace(/\s+/g, ' '),
            cfi: view.getCFI(item.index, range),
            breakAfter: breakAfter ? 'true' : 'false',
        });
        ranges.push({ range, index: sentences.length - 1, cfi: sentences.at(-1).cfi });
    }

    return { sentences, ranges };
}

export async function prepareSpeech(view) {
    const sentences = [];
    const currentIndex = view.lastLocation?.section?.current ?? 0;
    const current = view.renderer?.getContents?.()?.find(item => item.index === currentIndex);
    let foundStart = false;

    for (let index = 0; index < view.book.sections.length; index++) {
        const section = view.book.sections[index];
        if (!section || section.linear === 'no' || !section.createDocument) {
            continue;
        }

        const doc = index === currentIndex && current ? current.doc : await section.createDocument();
        if (!doc?.body) {
            continue;
        }

        const collected = collectDocumentSpeech(view, { doc, index }, null);
        const title = doc.querySelector('h1,h2,h3')?.textContent?.trim() || `Chapter ${index + 1}`;

        for (let sentence = 0; sentence < collected.sentences.length; sentence++) {
            let isStart = false;
            if (!foundStart && index >= currentIndex) {
                const start = index === currentIndex ? view.lastLocation?.range : null;
                isStart = !start
                    || collected.ranges[sentence].range.comparePoint(start.startContainer, start.startOffset) <= 0;
                if (isStart) {
                    foundStart = true;
                }
            }

            sentences.push({
                ...collected.sentences[sentence],
                section: String(index),
                title,
                isStart: String(isStart),
            });
        }

        await new Promise(resolve => setTimeout(resolve, 0));
    }

    return sentences;
}

export async function nextSpeechSection(view) {
    const index = view.renderer?.getContents?.()?.[0]?.index;
    if (index == null) {
        return false;
    }

    for (let next = index + 1; next < view.book.sections.length; next++) {
        if (view.book.sections[next].linear === 'no') {
            continue;
        }

        await view.goTo(next);
        return view.renderer.getContents().some(content => content.index === next);
    }

    return false;
}
