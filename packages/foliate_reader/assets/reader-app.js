import { ReaderBookSearch } from './reader-search.js';
import { View } from './foliate-js/view.js';
import { Overlayer } from './foliate-js/overlayer.js';
import { prepareNarration, highlightNarration } from './reader-narration.js';
import { collectSpeech, nextSpeechSection, prepareSpeech } from './reader-tts.js';

const view = document.getElementById('viewer');
const bookSearch = new ReaderBookSearch(view);
const annotationsMap = new Map();
let currentTtsHighlight = null;
let currentMediaOverlayHighlight = null;
let clearMediaOverlayHighlight = null;
let currentStyles = null;
let currentTtsRanges = [];
let nativeSpeechActive = false;
let currentSpeechDocument = null;
let currentPageGeometry = null;
let pageGeometryFrame = null;

function applyPageGeometry() {
    pageGeometryFrame = null;
    const renderer = view?.renderer;
    if (!renderer || !currentPageGeometry) {
        return;
    }

    const bounds = renderer.getBoundingClientRect();
    const doc = renderer.getContents?.()[0]?.doc;
    const writingMode = doc?.body ? doc.defaultView.getComputedStyle(doc.body).writingMode : '';
    const vertical = writingMode === 'vertical-rl' || writingMode === 'vertical-lr';
    const inlineSize = vertical ? bounds.height : bounds.width;
    const blockSize = vertical ? bounds.width : bounds.height;
    if (inlineSize <= 0 || blockSize <= 0) {
        return;
    }

    const margin = Math.min(currentPageGeometry.margin, inlineSize * 0.2);
    const verticalMargin = Math.min(currentPageGeometry.verticalMargin, blockSize * 0.2);
    const scrolled = renderer.getAttribute('flow') === 'scrolled';
    const gap = scrolled ? margin / (inlineSize + margin) : margin / inlineSize;
    const attributes = {
        margin: `${verticalMargin}px`,
        gap: `${(gap * 100).toFixed(4)}%`,
        'max-inline-size': `${currentPageGeometry.width}px`,
    };

    for (const [name, value] of Object.entries(attributes)) {
        if (renderer.getAttribute(name) !== value) {
            renderer.setAttribute(name, value);
        }
    }
}

function schedulePageGeometry() {
    if (currentPageGeometry && pageGeometryFrame === null) {
        pageGeometryFrame = requestAnimationFrame(applyPageGeometry);
    }
}

const pageGeometryObserver = new ResizeObserver(schedulePageGeometry);
pageGeometryObserver.observe(view);
view.addEventListener('load', schedulePageGeometry);
window.addEventListener('pagehide', () => {
    bookSearch.clearHighlight();
    pageGeometryObserver.disconnect();
    if (pageGeometryFrame !== null) {
        cancelAnimationFrame(pageGeometryFrame);
        pageGeometryFrame = null;
    }
}, { once: true });

function refreshSpeechRanges() {
    if (!nativeSpeechActive) {
        return;
    }

    const contents = view.renderer?.getContents?.();
    const item = contents?.find(item => item.index === view.lastLocation?.section?.current) ?? contents?.[0];
    if (!item?.doc || currentSpeechDocument === item.doc) {
        return;
    }
    currentSpeechDocument = item.doc;
    currentTtsRanges = collectSpeech(view, false).ranges;
}

let nativeNarrationActive = false;

const interactiveSelector = [
    'a',
    'button',
    'input',
    'textarea',
    'select',
    'option',
    'label',
    'summary',
    'video',
    'audio',
    '[contenteditable="true"]',
    '[role="button"]'
].join(',');

const isInteractiveTarget = target => !!target?.closest?.(interactiveSelector);

const hasActiveSelection = doc => {
    const selection = doc?.defaultView?.getSelection();
    return !!selection && !selection.isCollapsed;
};

const readerHasActiveSelection = () => {
    const contents = view?.renderer?.getContents?.() || [];
    return contents.some(item => hasActiveSelection(item.doc));
};

const isAnnotationAtPoint = (index, event) => {
    const contents = view?.renderer?.getContents?.() || [];
    const item = contents.find(content => content.index === index);
    const [value] = item?.overlayer?.hitTest?.(event) || [];
    return !!value && annotationsMap.has(value);
};

const getReaderClientX = (event, doc) => {
    if (Number.isFinite(event.screenX)) {
        return event.screenX - window.screenX;
    }

    try {
        const frame = doc?.defaultView?.frameElement;
        const rect = frame?.getBoundingClientRect?.();
        if (rect && frame.offsetWidth > 0) {
            return rect.left + event.clientX * rect.width / frame.offsetWidth;
        }
    } catch (error) {
        console.error(error);
    }

    return event.screenX - window.screenX;
};

const getPageTurnDirection = (clientX, viewportWidth) => {
    if (!Number.isFinite(clientX) || !Number.isFinite(viewportWidth) || viewportWidth <= 0) {
        return false;
    }

    if (view.renderer?.getAttribute('flow') === 'scrolled') {
        return 0;
    }

    const edgeWidth = Math.min(120, viewportWidth / 3);
    if (clientX <= edgeWidth) {
        return -1;
    }

    if (clientX >= viewportWidth - edgeWidth) {
        return 1;
    }

    return 0;
};

const turnPageAtEdge = (clientX, viewportWidth) => {
    const direction = getPageTurnDirection(clientX, viewportWidth);
    if (!direction) {
        return false;
    }

    const navigation = direction < 0 ? view.prev() : view.next();
    navigation.catch(error => console.error(error));
    return true;
};

const getReaderRect = (rect, doc) => {
    try {
        const frame = doc?.defaultView?.frameElement;
        const frameRect = frame?.getBoundingClientRect?.();
        if (frameRect && frame.offsetWidth > 0 && frame.offsetHeight > 0) {
            const scaleX = frameRect.width / frame.offsetWidth;
            const scaleY = frameRect.height / frame.offsetHeight;
            const left = frameRect.left + rect.left * scaleX;
            const top = frameRect.top + rect.top * scaleY;
            const width = rect.width * scaleX;
            const height = rect.height * scaleY;
            return { left, top, right: left + width, bottom: top + height, width, height };
        }
    } catch (error) {
        console.error(error);
    }

    return rect;
};

const getVisibleSelectionRect = (range, doc) => {
    const rects = Array.from(range.getClientRects(), rect => getReaderRect(rect, doc));
    return rects.find(rect =>
        rect.right > 0 && rect.left < window.innerWidth
        && rect.bottom > 0 && rect.top < window.innerHeight)
        || getReaderRect(range.getBoundingClientRect(), doc);
};

const resolveURL = (url, relativeTo) => {
    try {
        if (relativeTo.includes(':')) {
            return new URL(url, relativeTo);
        }

        const root = 'https://invalid.invalid/';
        const obj = new URL(url, root + relativeTo);
        obj.search = '';
        return decodeURI(obj.href.replace(root, ''));
    } catch (e) {
        return url;
    }
};

const parseClock = str => {
    if (!str) {
        return;
    }

    const parts = str.split(':').map(x => parseFloat(x));
    if (parts.length === 3) {
        const [h, m, s] = parts;
        return h * 60 * 60 + m * 60 + s;
    }

    if (parts.length === 2) {
        const [m, s] = parts;
        return m * 60 + s;
    }

    const [x, unit] = str.split(/(?=[^\d.])/) || [];
    const n = parseFloat(x);
    const f = unit === 'h' ? 60 * 60
        : unit === 'min' ? 60
        : unit === 'ms' ? .001
        : 1;
    return n * f;
};

async function ensureEntriesForSection(sectionIndex) {
    if (!view.mediaOverlay) {
        return;
    }

    const section = view.book.sections[sectionIndex];
    if (section && section.mediaOverlay) {
        const smilHref = section.mediaOverlay.href;
        if (view.mediaOverlay.entriesCache && view.mediaOverlay.entriesCache.has(smilHref)) {
            view.mediaOverlay.entries = view.mediaOverlay.entriesCache.get(smilHref);
            return;
        }
        try {
            await view.mediaOverlay.loadXML(smilHref);
        } catch (e) {
            console.error(e);
        }
    }
}

function applyStylesToDoc(doc, css) {
    if (!doc) {
        return;
    }

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

            const activeClass = (view.book && view.book.media && view.book.media.activeClass) || 'undefined';
            const mediaOverlayOverride = `
                .${activeClass}, .-epub-media-overlay-active {
                    background-color: transparent !important;
                }
            `;
            const fullCss = (css || '') + mediaOverlayOverride;
            if (styleEl && styleEl.textContent !== fullCss) {
                styleEl.textContent = fullCss;
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
            if (view.mediaOverlay) {
                let moState = 'stopped';
                const updateTrackedState = (state) => {
                    if (moState !== state) {
                        moState = state;
                        view.mediaOverlay.state = state;
                        window.flutter_inappwebview.callHandler('onMediaOverlayStateChanged', {
                            state: state
                        });
                    }
                };

                view.mediaOverlay.state = 'stopped';
                view.mediaOverlay.entriesCache = new Map();

                const originalStart = view.mediaOverlay.start;
                view.mediaOverlay.start = async function(sectionIndex, filter) {
                    updateTrackedState('playing');
                    return originalStart.call(this, sectionIndex, filter);
                };

                const originalPause = view.mediaOverlay.pause;
                view.mediaOverlay.pause = function() {
                    updateTrackedState('paused');
                    return originalPause.call(this);
                };

                const originalResume = view.mediaOverlay.resume;
                view.mediaOverlay.resume = function() {
                    updateTrackedState('playing');
                    return originalResume.call(this);
                };

                const originalStop = view.mediaOverlay.stop;
                view.mediaOverlay.stop = function() {
                    updateTrackedState('stopped');
                    return originalStop.call(this);
                };

                const originalLoadXML = view.mediaOverlay.loadXML;
                view.mediaOverlay.loadXML = async function(href) {
                    const doc = await originalLoadXML.call(this, href);
                    try {
                        const pars = doc.getElementsByTagNameNS('*', 'par');
                        const entries = [];

                        for (const $par of pars) {
                            const textEl = $par.getElementsByTagNameNS('*', 'text')[0];
                            const audioEl = $par.getElementsByTagNameNS('*', 'audio')[0];
                            if (textEl && audioEl) {
                                const text = resolveURL(textEl.getAttribute('src'), href);
                                const src = resolveURL(audioEl.getAttribute('src'), href);
                                const begin = parseClock(audioEl.getAttribute('clipBegin'));
                                const end = parseClock(audioEl.getAttribute('clipEnd'));
                                const last = entries[entries.length - 1];
                                if (last && last.src === src) {
                                    last.items.push({ text, begin, end });
                                } else {
                                    entries.push({ src, items: [{ text, begin, end }] });
                                }
                            }
                        }
                        view.mediaOverlay.entries = entries;
                        if (!view.mediaOverlay.entriesCache) {
                            view.mediaOverlay.entriesCache = new Map();
                        }
                        view.mediaOverlay.entriesCache.set(href, entries);
                    } catch (e) {
                        console.error(e);
                    }

                    return doc;
                };

                let activeAudioInstances = new Set();
                const OriginalAudio = globalThis.Audio;
                if (!OriginalAudio._original) {
                    globalThis.Audio = class extends OriginalAudio {
                        constructor(src) {
                            super(src);
                            const self = this;
                            activeAudioInstances.add(this);
                            this.addEventListener('playing', () => {
                                if (moState !== 'playing') {
                                    updateTrackedState('playing');
                                }
                            });
                            this.addEventListener('pause', () => {
                                setTimeout(() => {
                                    if (self.paused && !self.ended && moState === 'playing') {
                                        updateTrackedState('paused');
                                    }
                                }, 50);
                            });
                            this.addEventListener('ended', () => {
                                activeAudioInstances.delete(self);
                                setTimeout(() => {
                                    if (activeAudioInstances.size === 0) {
                                        updateTrackedState('stopped');
                                    }
                                }, 200);
                            });
                            this.addEventListener('error', () => {
                                activeAudioInstances.delete(self);
                                updateTrackedState('stopped');
                            });
                        }
                    };
                    globalThis.Audio._original = OriginalAudio;
                }

                clearMediaOverlayHighlight = () => {
                    if (currentMediaOverlayHighlight) {
                        const { item, key } = currentMediaOverlayHighlight;
                        try {
                            if (item && item.overlayer) {
                                item.overlayer.remove(key);
                            }
                        } catch (e) {}
                        currentMediaOverlayHighlight = null;
                    }
                };

                view.mediaOverlay.addEventListener('highlight', e => {
                    clearMediaOverlayHighlight();
                    const resolved = view.resolveNavigation(e.detail.text);
                    if (resolved) {
                        const contents = view.renderer.getContents();
                        const item = contents.find(x => x.index === resolved.index);
                        if (item && item.overlayer) {
                            const el = resolved.anchor(item.doc);
                            if (el) {
                                const range = item.doc.createRange();
                                range.selectNodeContents(el);
                                const key = 'yaabsa-media-overlay-highlight';
                                item.overlayer.add(key, range, Overlayer.highlight, { color: '#FFEB3B' });
                                currentMediaOverlayHighlight = { item, key };
                            }
                        }
                    }
                    window.flutter_inappwebview.callHandler('onMediaOverlayHighlight', e.detail);
                });
                view.mediaOverlay.addEventListener('unhighlight', e => {
                    clearMediaOverlayHighlight();
                    window.flutter_inappwebview.callHandler('onMediaOverlayUnhighlight', e.detail);
                });
                view.mediaOverlay.addEventListener('statechange', e => {
                    window.flutter_inappwebview.callHandler('onMediaOverlayStateChanged', {
                        state: e.detail.state
                    });
                });
                view.mediaOverlay.addEventListener('error', e => {
                    window.flutter_inappwebview.callHandler('onMediaOverlayError', e.detail ? e.detail.message : '');
                });
            }
            window.flutter_inappwebview.callHandler('onBookLoaded', {
                metadata: view.book.metadata || {},
                toc: view.book.toc || [],
                pageList: view.book.pageList || [],
                dir: view.book.dir || 'ltr',
                hasMediaOverlays: !!view.mediaOverlay
            });
        } catch (e) {
            window.flutter_inappwebview.callHandler('onError', e.toString(), e.stack || '');
        }
    },
    async close() {
        bookSearch.reset();
        currentPageGeometry = null;
        if (pageGeometryFrame !== null) {
            cancelAnimationFrame(pageGeometryFrame);
            pageGeometryFrame = null;
        }
        try {
            if (view && typeof view.close === 'function') {
                view.close();
            }
            annotationsMap.clear();
            currentStyles = null;
            currentTtsHighlight = null;
            currentTtsRanges = [];
            nativeSpeechActive = false;
            currentSpeechDocument = null;
            if (clearMediaOverlayHighlight) {
                clearMediaOverlayHighlight();
            }
            clearMediaOverlayHighlight = null;
            currentMediaOverlayHighlight = null;
            if (globalThis.Audio._original) {
                globalThis.Audio = globalThis.Audio._original;
            }
        } catch (e) {}
    },
    async goTo(target) {
        await view.goTo(target);
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
        if (currentStyles === css) {
            return;
        }

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
    setPageGeometry(margin, width, verticalMargin = margin) {
        currentPageGeometry = {
            margin: Number.isFinite(margin) && margin >= 0 ? margin : 32,
            verticalMargin: Number.isFinite(verticalMargin) && verticalMargin >= 0 ? verticalMargin : 32,
            width: Number.isFinite(width) && width > 0 ? width : 720,
        };
        schedulePageGeometry();
    },
    setFlow(flow) {
        if (view && view.renderer && typeof view.renderer.setAttribute === 'function') {
            view.renderer.setAttribute('flow', flow);
            schedulePageGeometry();
        }
    },
    setMaxColumnCount(count) {
        if (view && view.renderer && typeof view.renderer.setAttribute === 'function') {
            view.renderer.setAttribute('max-column-count', count.toString());
        }
    },
    async addAnnotationFromSelection(type, color, note) {
        if (!view || !view.renderer || typeof view.renderer.getContents !== 'function') {
            return null;
        }

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
    async search(query, maxResults = 300, notifyResults = true) {
        const results = await bookSearch.search(query, maxResults);
        if (results === null) {
            return [];
        }

        if (notifyResults) {
            window.flutter_inappwebview.callHandler('onSearchResults', results);
        }
        return results;
    },
    clearSearch() {
        bookSearch.cancel();
    },
    highlightSearchResult(cfi) {
        bookSearch.highlight(cfi);
    },
    getCurrentSectionText() {
        if (!view || !view.renderer || typeof view.renderer.getContents !== 'function') {
            return '';
        }

        const contents = view.renderer.getContents();
        if (contents && contents.length > 0) {
            return contents[0].doc.body.innerText.trim();
        }

        return '';
    },
    getTtsSentences() {
        const { sentences, ranges } = collectSpeech(view);
        currentTtsRanges = ranges;
        return sentences;
    },
    async prepareSpeech() {
        return prepareSpeech(view);
    },
    setSpeechActive(active) {
        nativeSpeechActive = active;
        if (active) {
            refreshSpeechRanges();
        } else {
            currentTtsRanges = [];
            currentSpeechDocument = null;
        }
    },
    async nextTtsSection() {
        return nextSpeechSection(view);
    },
    async prepareMediaOverlay(exportPath) {
        await view.mediaOverlay?.stop();
        return prepareNarration(view, exportPath);
    },
    async highlightNarrationTarget(target) {
        nativeNarrationActive = !!target;
        clearMediaOverlayHighlight?.();
        if (!target) {
            return;
        }

        const highlight = await highlightNarration(view, target);
        if (!highlight) {
            return;
        }

        const key = 'yaabsa-native-narration';
        highlight.item.overlayer.add(key, highlight.range, Overlayer.highlight, { color: '#FFEB3B' });
        currentMediaOverlayHighlight = { item: highlight.item, key };
    },
    async highlightCFI(cfi, color) {
        refreshSpeechRanges();
        if (currentTtsHighlight) {
            await view.deleteAnnotation(currentTtsHighlight);
        }
        currentTtsHighlight = { value: cfi, color: color || '#FFEB3B', type: 'highlight', note: '' };
        await view.addAnnotation(currentTtsHighlight);
    },
    async clearTtsHighlight() {
        currentTtsRanges = [];
        currentSpeechDocument = null;
        if (currentTtsHighlight) {
            await view.deleteAnnotation(currentTtsHighlight);
            currentTtsHighlight = null;
        }
    },
    async startMediaOverlay() {
        if (view.mediaOverlay) {
            const contents = view.renderer.getContents();
            if (contents && contents.length > 0 && view.lastLocation && view.lastLocation.range) {
                const currentContent = contents[0];
                const doc = currentContent.doc;
                const range = view.lastLocation.range;
                await ensureEntriesForSection(currentContent.index);
                if (view.mediaOverlay.entries) {
                    let targetItem = null;

                    for (const entry of view.mediaOverlay.entries) {
                        for (const item of entry.items) {
                            const parts = item.text.split('#');
                            if (parts.length > 1) {
                                const id = parts[1];
                                const el = doc.getElementById(id);
                                if (el) {
                                    try {
                                        const cmp = range.comparePoint(el, 0);
                                        if (cmp >= 0) {
                                            targetItem = item;
                                            break;
                                        }
                                    } catch (err) {}
                                }
                            }
                        }

                        if (targetItem) {
                            break;
                        }
                    }

                    if (targetItem) {
                        view.mediaOverlay.start(currentContent.index, x => x.text === targetItem.text);
                        return;
                    }
                }
            }
            view.startMediaOverlay();
        }
    },
    pauseMediaOverlay() {
        if (view.mediaOverlay) {
            view.mediaOverlay.pause();
        }
    },
    resumeMediaOverlay() {
        if (view.mediaOverlay) {
            view.mediaOverlay.resume();
        }
    },
    stopMediaOverlay() {
        if (view.mediaOverlay) {
            view.mediaOverlay.stop();
        }
    },
    highlightMediaOverlay(cfi, color) {
    },
    clearMediaOverlayHighlight() {
    }
};

view.addEventListener('relocate', e => {
    refreshSpeechRanges();
    window.flutter_inappwebview.callHandler('onRelocate', {
        cfi: e.detail.cfi,
        fraction: e.detail.fraction,
        location: e.detail.location,
        tocItem: e.detail.tocItem,
        pageItem: e.detail.pageItem
    });
});

view.addEventListener('click', e => {
    if (isInteractiveTarget(e.target) || readerHasActiveSelection()) {
        return;
    }

    if (turnPageAtEdge(e.clientX, window.innerWidth)) {
        e.preventDefault();
        e.stopPropagation();
        return;
    }
    window.flutter_inappwebview.callHandler('onCenterTap');
});

view.addEventListener('load', e => {
    const { doc, index } = e.detail;
    let suppressPageClickUntil = 0;
    let touchStart = null;

    applyStylesToDoc(doc, currentStyles || '');
    if (currentStyles && view.renderer && typeof view.renderer.setStyles === 'function') {
        try {
            view.renderer.setStyles(currentStyles);
        } catch (err) {}
    }

    const doubleTapInterval = 500;
    let singleTapTimer = null;
    let previousTouchTap = null;
    const speechIsActive = () => nativeNarrationActive || currentTtsRanges.length > 0
        || ['playing', 'paused'].includes(view.mediaOverlay?.state);
    const cancelSingleTap = () => {
        clearTimeout(singleTapTimer);
        singleTapTimer = null;
    };
    const handleSingleTap = clientX => {
        if (hasActiveSelection(doc) || !view.renderer.getContents().some(item => item.doc === doc)) {
            return;
        }

        if (!turnPageAtEdge(clientX, window.innerWidth)) {
            window.flutter_inappwebview.callHandler('onCenterTap');
        }
    };
    const deferSingleTap = clientX => {
        cancelSingleTap();
        singleTapTimer = setTimeout(() => {
            singleTapTimer = null;
            handleSingleTap(clientX);
        }, doubleTapInterval);
    };
    const jumpToSpokenPosition = async (targetElement, point) => {
        if (nativeNarrationActive) {
            await ensureEntriesForSection(index);
            let element = targetElement;

            while (element && element !== doc.body) {
                if (element.id) {
                    const target = view.mediaOverlay?.entries?.flatMap(entry => entry.items).find(item => {
                        const [path, fragment] = item.text.split('#');
                        return path === view.book.sections[index].id && decodeURIComponent(fragment || '') === element.id;
                    })?.text;
                    if (target) {
                        window.flutter_inappwebview.callHandler('onNarrationSeek', target);
                        return true;
                    }
                }
                element = element.parentElement;
            }
        }

        if (view.mediaOverlay && (view.mediaOverlay.state === 'playing' || view.mediaOverlay.state === 'paused')) {
            await ensureEntriesForSection(index);
            if (view.mediaOverlay.entries) {
                let el = targetElement;

                while (el && el !== doc.body) {
                    if (el.id) {
                        const id = el.id;

                        for (let i = 0; i < view.mediaOverlay.entries.length; i++) {
                            const entry = view.mediaOverlay.entries[i];

                            for (let j = 0; j < entry.items.length; j++) {
                                const item = entry.items[j];
                                if (item.text.endsWith('#' + id)) {
                                    if (view.mediaOverlay.state === 'paused') {
                                        view.mediaOverlay.resume();
                                    }
                                    view.mediaOverlay.start(index, x => x.text === item.text);
                                    return true;
                                }
                            }
                        }
                    }
                    el = el.parentElement;
                }
            }
        }

        if (currentTtsRanges.length > 0) {
            const clickRange = doc.caretRangeFromPoint?.(point.clientX, point.clientY);
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
                    window.flutter_inappwebview.callHandler('onTtsJumpToSentence', match.cfi);
                    return true;
                }
            }
        }

        return false;
    };
    doc.defaultView.addEventListener('pagehide', cancelSingleTap, { once: true });
    doc.addEventListener('mousedown', ev => {
        if (ev.detail !== 2 || !speechIsActive() || hasActiveSelection(doc)
            || isInteractiveTarget(ev.target) || isAnnotationAtPoint(index, ev)) {
            return;
        }
        cancelSingleTap();
        ev.preventDefault();
    });
    doc.addEventListener('dblclick', ev => {
        if (performance.now() < suppressPageClickUntil || !speechIsActive()
            || hasActiveSelection(doc) || isInteractiveTarget(ev.target) || isAnnotationAtPoint(index, ev)) {
            return;
        }
        cancelSingleTap();
        ev.preventDefault();
        ev.stopPropagation();
        jumpToSpokenPosition(ev.target, ev).catch(error => console.error(error));
    });
    const stopPagingDuringSelection = ev => {
        if (hasActiveSelection(doc)) {
            ev.stopPropagation();
        }
    };
    doc.addEventListener('touchmove', stopPagingDuringSelection, { capture: true, passive: true });
    doc.addEventListener('touchend', stopPagingDuringSelection, { capture: true, passive: true });
    doc.addEventListener('touchstart', ev => {
        if (ev.touches.length !== 1) {
            touchStart = null;
            return;
        }

        const touch = ev.touches[0];
        if (speechIsActive() && previousTouchTap && performance.now() - previousTouchTap.time <= doubleTapInterval
            && Math.hypot(touch.screenX - previousTouchTap.x, touch.screenY - previousTouchTap.y) <= 24
            && !hasActiveSelection(doc) && !isInteractiveTarget(ev.target)
            && !isAnnotationAtPoint(index, touch)) {
            ev.preventDefault();
        }
        touchStart = {
            x: touch.screenX,
            y: touch.screenY,
            time: ev.timeStamp,
            target: ev.target
        };
    }, { passive: false });
    doc.addEventListener('touchmove', ev => {
        const touch = ev.touches[0];
        if (touchStart && touch && Math.hypot(touch.screenX - touchStart.x, touch.screenY - touchStart.y) > 18) {
            cancelSingleTap();
            previousTouchTap = null;
        }
    }, { passive: true });
    doc.addEventListener('touchend', ev => {
        const touch = ev.changedTouches[0];
        const start = touchStart;
        touchStart = null;
        if (!touch || !start) {
            return;
        }

        const distance = Math.hypot(touch.screenX - start.x, touch.screenY - start.y);
        if (distance > 18 || ev.timeStamp - start.time > 500) {
            return;
        }

        if (hasActiveSelection(doc) || isInteractiveTarget(start.target)) {
            return;
        }

        if (isAnnotationAtPoint(index, { x: touch.clientX, y: touch.clientY })) {
            return;
        }

        if (speechIsActive()) {
            const now = performance.now();
            const previous = previousTouchTap;
            const isDoubleTap = previous && now - previous.time <= doubleTapInterval
                && Math.hypot(touch.screenX - previous.x, touch.screenY - previous.y) <= 24;
            suppressPageClickUntil = now + 750;
            ev.preventDefault();
            ev.stopPropagation();
            if (isDoubleTap) {
                previousTouchTap = null;
                cancelSingleTap();
                jumpToSpokenPosition(start.target, touch).catch(error => console.error(error));
            } else {
                previousTouchTap = { time: now, x: touch.screenX, y: touch.screenY };
                deferSingleTap(touch.screenX - window.screenX);
            }

            return;
        }

        const clientX = touch.screenX - window.screenX;
        if (!getPageTurnDirection(clientX, window.innerWidth)) {
            return;
        }

        suppressPageClickUntil = performance.now() + 750;
        ev.preventDefault();
        ev.stopPropagation();
        requestAnimationFrame(() => turnPageAtEdge(clientX, window.innerWidth));
    }, { passive: false });
    doc.addEventListener('click', ev => {
        if (performance.now() < suppressPageClickUntil || isAnnotationAtPoint(index, ev)
            || hasActiveSelection(doc) || isInteractiveTarget(ev.target)) {
            return;
        }

        if (speechIsActive()) {
            ev.preventDefault();
            ev.stopPropagation();
            if (ev.detail < 2) {
                deferSingleTap(getReaderClientX(ev, doc));
            }

            return;
        }

        if (turnPageAtEdge(getReaderClientX(ev, doc), window.innerWidth)) {
            ev.preventDefault();
            ev.stopPropagation();
            return;
        }
        window.flutter_inappwebview.callHandler('onCenterTap');
    });
    doc.addEventListener('selectionchange', () => {
        const selection = doc.defaultView.getSelection();
        if (selection && !selection.isCollapsed) {
            cancelSingleTap();
            previousTouchTap = null;
            const range = selection.getRangeAt(0);
            const cfi = view.getCFI(index, range);
            const text = selection.toString();
            const rect = getVisibleSelectionRect(range, doc);
            window.flutter_inappwebview.callHandler('onSelectionChanged', {
                cfi,
                text,
                index,
                x: rect.left + rect.width / 2,
                y: rect.top,
                height: rect.height
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
        const resolved = view.resolveNavigation(annotation.value);
        if (resolved && resolved.index === index) {
            view.addAnnotation(annotation);
        }
    }
});

view.addEventListener('draw-annotation', e => {
    const { draw, annotation } = e.detail;
    const { color, type } = annotation;
    if (type === 'bookmark') {
        return;
    }
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
