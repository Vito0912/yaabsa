import { View } from './foliate-js/view.js';
import { Overlayer } from './foliate-js/overlayer.js';

const view = document.getElementById('viewer');
const annotationsMap = new Map();
let currentTtsHighlight = null;
let currentStyles = null;
let currentTtsRanges = [];

function applyStylesToDoc(doc, css) {
    if (!doc) return;
    const inject = () => {
        try {
            let styleEl = doc.getElementById('yaabsa-reader-styles');
            if (!styleEl) {
                styleEl = doc.createElement('style');
                styleEl.id = 'yaabsa-reader-styles';
                const target = doc.head || doc.body || doc.documentElement;
                if (target) {
                    target.appendChild(styleEl);
                }
            }
            if (styleEl && styleEl.textContent !== css) {
                styleEl.textContent = css;
            }
        } catch (e) {}
    };
    inject();
    setTimeout(inject, 100);
}

window.FoliateReaderAPI = {
    async openBook(url, lastLocation, flow, maxColumnCount, initialStyles) {
        try {
            if (initialStyles) {
                currentStyles = initialStyles;
            }
            await view.open(url);
            if (view.renderer) {
                if (flow) {
                    view.renderer.setAttribute('flow', flow);
                }
                if (maxColumnCount) {
                    view.renderer.setAttribute('max-column-count', maxColumnCount.toString());
                }
            }
            await view.init({ lastLocation });
            window.flutter_inappwebview.callHandler('onBookLoaded', {
                metadata: view.book.metadata || {},
                toc: view.book.toc || [],
                pageList: view.book.pageList || [],
                dir: view.book.dir || 'ltr'
            });
        } catch (e) {
            window.flutter_inappwebview.callHandler('onError', e.toString());
        }
    },
    async close() {
        try {
            if (view && typeof view.close === 'function') {
                view.close();
            }
            annotationsMap.clear();
            currentStyles = null;
            currentTtsHighlight = null;
            currentTtsRanges = [];
        } catch (e) {}
    },
    async goTo(target) {
        const resolved = await view.goTo(target);
        return resolved;
    },
    async goToFraction(frac) {
        await view.goToFraction(frac);
    },
    async next() {
        await view.next();
    },
    async prev() {
        await view.prev();
    },
    async addAnnotation(annotation) {
        const key = annotation.value;
        annotationsMap.set(key, annotation);
        const result = await view.addAnnotation(annotation);
        return result;
    },
    async deleteAnnotation(annotation) {
        const key = annotation.value;
        annotationsMap.delete(key);
        await view.deleteAnnotation(annotation);
    },
    deselect() {
        view.deselect();
    },
    setStyles(css) {
        currentStyles = css;
        if (view && view.renderer && typeof view.renderer.setStyles === 'function') {
            try {
                view.renderer.setStyles(css);
            } catch (e) {}
        }
        if (view && view.renderer && typeof view.renderer.getContents === 'function') {
            const contents = view.renderer.getContents();
            if (contents) {
                for (const item of contents) {
                    applyStylesToDoc(item.doc, css);
                }
            }
        }
    },
    setFlow(flow) {
        if (view && view.renderer && typeof view.renderer.setAttribute === 'function') {
            view.renderer.setAttribute('flow', flow);
        }
    },
    setMaxColumnCount(count) {
        if (view && view.renderer && typeof view.renderer.setAttribute === 'function') {
            view.renderer.setAttribute('max-column-count', count.toString());
        }
    },
    async addAnnotationFromSelection(type, color, note) {
        if (!view || !view.renderer || typeof view.renderer.getContents !== 'function') return null;
        const contents = view.renderer.getContents();
        if (contents) {
            for (const item of contents) {
                const selection = item.doc.defaultView.getSelection();
                if (selection && !selection.isCollapsed) {
                    const range = selection.getRangeAt(0);
                    const cfi = view.getCFI(item.index, range);
                    selection.removeAllRanges();
                    const annotation = { value: cfi, color, type, note: note || '' };
                    annotationsMap.set(cfi, annotation);
                    await view.addAnnotation(annotation);
                    window.flutter_inappwebview.callHandler('onAnnotationAdded', annotation);
                    return cfi;
                }
            }
        }
        return null;
    },
    async search(query) {
        const results = [];
        try {
            for await (const result of view.search({ query })) {
                if (result === 'done') break;
                if (result.subitems) {
                    results.push(...result.subitems);
                } else if (result.cfi) {
                    results.push(result);
                }
            }
            window.flutter_inappwebview.callHandler('onSearchResults', results);
        } catch (e) {
            window.flutter_inappwebview.callHandler('onError', e.toString());
        }
    },
    clearSearch() {
        view.clearSearch();
    },
    getCurrentSectionText() {
        if (!view || !view.renderer || typeof view.renderer.getContents !== 'function') return '';
        const contents = view.renderer.getContents();
        if (contents && contents.length > 0) {
            return contents[0].doc.body.innerText.trim();
        }
        return '';
    },
    getTtsSentences() {
        if (!view || !view.renderer || typeof view.renderer.getContents !== 'function') return [];
        const contents = view.renderer.getContents();
        if (!contents || contents.length === 0) return [];
        const item = contents[0];
        const doc = item.doc;

        let startNode = doc.body;
        let startOffset = 0;

        if (view.lastLocation && view.lastLocation.range) {
            const r = view.lastLocation.range;
            if (r.startContainer.nodeType === Node.ELEMENT_NODE) {
                if (r.startContainer.childNodes.length > r.startOffset) {
                    startNode = r.startContainer.childNodes[r.startOffset];
                    startOffset = 0;
                } else {
                    startNode = r.startContainer;
                    startOffset = 0;
                }
            } else {
                startNode = r.startContainer;
                startOffset = r.startOffset;
            }
        }

        const textNodes = [];
        const walker = doc.createTreeWalker(doc.body, NodeFilter.SHOW_TEXT, null, false);
        let foundStart = false;
        
        while (walker.nextNode()) {
            const node = walker.currentNode;
            if (!foundStart) {
                if (node === startNode || startNode.contains(node) || (startNode.compareDocumentPosition(node) & Node.DOCUMENT_POSITION_FOLLOWING)) {
                    foundStart = true;
                    const offset = (node === startNode) ? startOffset : 0;
                    textNodes.push({ node, offset });
                }
            } else {
                textNodes.push({ node, offset: 0 });
            }
        }

        if (textNodes.length === 0) {
            walker.currentNode = doc.body;
            while (walker.nextNode()) {
                textNodes.push({ node: walker.currentNode, offset: 0 });
            }
        }

        let fullText = '';
        const mappings = [];
        for (const entry of textNodes) {
            const textContent = entry.node.textContent.substring(entry.offset);
            const startIdx = fullText.length;
            fullText += textContent + ' ';
            mappings.push({
                start: startIdx,
                end: fullText.length,
                node: entry.node,
                offset: entry.offset
            });
        }

        const sentenceRegex = /[^.!?\n]+[.!?\n]+/g;
        const sentences = [];
        let match;
        
        currentTtsRanges = [];
        while ((match = sentenceRegex.exec(fullText)) !== null) {
            const sentenceText = match[0].trim();
            if (sentenceText.length === 0) continue;

            const startChar = match.index;
            const endChar = match.index + match[0].length;

            const startMap = mappings.find(m => startChar >= m.start && startChar < m.end);
            const endMap = mappings.find(m => endChar > m.start && endChar <= m.end);

            if (startMap && endMap) {
                try {
                    const range = doc.createRange();
                    range.setStart(startMap.node, startMap.offset + (startChar - startMap.start));
                    range.setEnd(endMap.node, endMap.offset + (endChar - endMap.start));
                    
                    const cfi = view.getCFI(item.index, range);
                    sentences.push({
                        text: sentenceText,
                        cfi: cfi
                    });
                    currentTtsRanges.push({ range, index: sentences.length - 1 });
                } catch (e) {
                }
            }
        }

        if (sentences.length === 0 && fullText.trim().length > 0) {
            sentences.push({
                text: fullText.trim(),
                cfi: view.lastLocation ? view.lastLocation.cfi : ''
            });
        }

        return sentences;
    },
    highlightCFI(cfi, color) {
        if (currentTtsHighlight) {
            view.deleteAnnotation(currentTtsHighlight);
        }
        currentTtsHighlight = { value: cfi, color: color || '#FFEB3B', type: 'highlight', note: '' };
        view.addAnnotation(currentTtsHighlight);
    },
    clearTtsHighlight() {
        currentTtsRanges = [];
        if (currentTtsHighlight) {
            view.deleteAnnotation(currentTtsHighlight);
            currentTtsHighlight = null;
        }
    }
};

view.addEventListener('relocate', e => {
    window.flutter_inappwebview.callHandler('onRelocate', {
        cfi: e.detail.cfi,
        fraction: e.detail.fraction,
        location: e.detail.location,
        tocItem: e.detail.tocItem,
        pageItem: e.detail.pageItem
    });
});

view.addEventListener('click', e => {
    if (!e.target.closest('a') && !e.target.closest('button')) {
        window.flutter_inappwebview.callHandler('onCenterTap');
    }
});

view.addEventListener('load', e => {
    const { doc, index } = e.detail;
    if (currentStyles) {
        applyStylesToDoc(doc, currentStyles);
    }
    if (currentStyles && view.renderer && typeof view.renderer.setStyles === 'function') {
        try {
            view.renderer.setStyles(currentStyles);
        } catch (err) {}
    }
    doc.addEventListener('click', ev => {
        const selection = doc.defaultView.getSelection();
        if ((!selection || selection.isCollapsed) && !ev.target.closest('a') && !ev.target.closest('button')) {
            if (currentTtsRanges.length > 0) {
                const clickRange = doc.caretRangeFromPoint(ev.clientX, ev.clientY);
                if (clickRange) {
                    const clickedNode = clickRange.startContainer;
                    const clickedOffset = clickRange.startOffset;
                    const match = currentTtsRanges.find(entry => {
                        try {
                            return entry.range.comparePoint(clickedNode, clickedOffset) === 0;
                        } catch (err) {
                            return false;
                        }
                    });
                    if (match) {
                        window.flutter_inappwebview.callHandler('onTtsJumpToSentence', match.index);
                        ev.preventDefault();
                        ev.stopPropagation();
                        return;
                    }
                }
            }
            window.flutter_inappwebview.callHandler('onCenterTap');
        }
    });
    doc.addEventListener('selectionchange', () => {
        const selection = doc.defaultView.getSelection();
        if (selection && !selection.isCollapsed) {
            const range = selection.getRangeAt(0);
            const cfi = view.getCFI(index, range);
            const text = selection.toString();
            window.flutter_inappwebview.callHandler('onSelectionChanged', {
                cfi,
                text,
                index
            });
        } else {
            window.flutter_inappwebview.callHandler('onSelectionCleared');
        }
    });
    window.flutter_inappwebview.callHandler('onSectionLoaded', { index });
});

view.addEventListener('create-overlay', e => {
    const { index } = e.detail;
    for (const annotation of annotationsMap.values()) {
        view.resolveNavigation(annotation.value).then(resolved => {
            if (resolved && resolved.index === index) {
                view.addAnnotation(annotation);
            }
        });
    }
});

view.addEventListener('draw-annotation', e => {
    const { draw, annotation } = e.detail;
    const { color, type } = annotation;
    if (type === 'underline') {
        draw(Overlayer.underline, { color });
    } else if (type === 'strikethrough') {
        draw(Overlayer.strikethrough, { color });
    } else if (type === 'squiggly') {
        draw(Overlayer.squiggly, { color });
    } else if (type === 'outline') {
        draw(Overlayer.outline, { color });
    } else {
        draw(Overlayer.highlight, { color });
    }
});

view.addEventListener('show-annotation', e => {
    const key = e.detail.value;
    const annotation = annotationsMap.get(key);
    if (annotation) {
        window.flutter_inappwebview.callHandler('onAnnotationClicked', annotation);
    }
});
