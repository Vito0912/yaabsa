const clock = value => {
    if (!value) {
        return 0;
    }

    const text = value.trim().replace(/^npt=/, '');
    if (text.includes(':')) {
        return text.split(':').reduce((total, part) => total * 60 + Number(part), 0);
    }

    const match = text.match(/^([\d.]+)(h|min|ms|s)?$/);
    if (!match) {
        throw new Error(`Invalid media overlay time: ${value}`);
    }

    const secondsPerUnit = { h: 3600, min: 60, ms: 0.001, s: 1 };
    const multiplier = secondsPerUnit[match[2]] ?? 1;

    return Number(match[1]) * multiplier;
};

const resolve = (href, base) => {
    const root = 'https://epub.invalid/';
    const resolved = new URL(href, new URL(base, root));
    resolved.search = '';
    return decodeURI(resolved.href.slice(root.length));
};

async function audioDuration(blob) {
    const url = URL.createObjectURL(blob);
    const audio = document.createElement('audio');
    try {
        return await new Promise((resolve, reject) => {
            const timer = setTimeout(() => reject(new Error('Narration metadata timed out')), 15000);

            audio.onloadedmetadata = () => {
                clearTimeout(timer);
                resolve(audio.duration);
            };
            audio.onerror = () => {
                clearTimeout(timer);
                reject(new Error('Unable to read narration audio'));
            };

            audio.preload = 'metadata';
            audio.src = url;
        });
    } finally {
        audio.removeAttribute('src');
        audio.load();
        URL.revokeObjectURL(url);
    }
}

const narrationCache = new WeakMap();

async function exportNarration(view, exportPath) {
    if (!view.mediaOverlay || !exportPath) {
        return [];
    }

    const files = new Map();
    const clips = [];

    for (let sectionIndex = 0; sectionIndex < view.book.sections.length; sectionIndex++) {
        const section = view.book.sections[sectionIndex];
        if (!section.mediaOverlay) {
            continue;
        }

        const href = section.mediaOverlay.href;
        const doc = await view.mediaOverlay.loadXML(href);
        const pars = Array.from(doc.getElementsByTagNameNS('*', 'par'));

        for (let index = 0; index < pars.length; index++) {
            const par = pars[index];
            const text = par.getElementsByTagNameNS('*', 'text')[0];
            const audio = par.getElementsByTagNameNS('*', 'audio')[0];
            if (!text || !audio) {
                continue;
            }

            const src = resolve(audio.getAttribute('src'), href);
            let file = files.get(src);
            if (!file) {
                const blob = await view.book.loadBlob(src);
                if (!blob) {
                    throw new Error('Narration audio is missing');
                }

                const mimeType = view.book.resources?.getItemByHref(src)?.mediaType || blob.type || 'application/octet-stream';
                const response = await fetch(exportPath, {
                    method: 'POST',
                    headers: { 'Content-Type': mimeType },
                    body: blob,
                });

                if (!response.ok) {
                    throw new Error('Unable to prepare narration audio');
                }
                file = { path: (await response.json()).path, mimeType, duration: null };
                files.set(src, file);
            }

            const begin = clock(audio.getAttribute('clipBegin'));
            let end;
            if (audio.hasAttribute('clipEnd')) {
                end = clock(audio.getAttribute('clipEnd'));
            } else {
                file.duration ??= await audioDuration(await view.book.loadBlob(src));
                end = file.duration;
            }

            if (!Number.isFinite(end) || !Number.isFinite(begin) || end <= begin) {
                throw new Error('Narration contains an invalid audio interval');
            }

            clips.push({
                path: file.path,
                mimeType: file.mimeType,
                begin,
                end,
                target: resolve(text.getAttribute('src'), href),
                sectionIndex,
            });
        }
    }

    return clips;
}

export async function prepareNarration(view, exportPath) {
    if (!view.mediaOverlay || !exportPath) {
        return [];
    }

    let preparation = narrationCache.get(view.book);
    if (!preparation) {
        const book = view.book;
        preparation = exportNarration(view, exportPath).catch(error => {
            narrationCache.delete(book);
            throw error;
        });
        narrationCache.set(book, preparation);
    }

    const clips = await preparation;
    const contents = view.renderer.getContents();
    const current = contents.find(item => item.index === view.resolveNavigation(view.lastLocation?.cfi)?.index) ?? contents[0];
    const range = view.lastLocation?.range;
    let startIndex = -1;
    if (current && range) {
        startIndex = clips.findIndex(clip => {
            if (clip.sectionIndex !== current.index) {
                return false;
            }

            const resolved = view.resolveNavigation(clip.target);
            const element = resolved?.anchor?.(current.doc);
            if (!element || typeof element !== 'object') {
                return false;
            }

            const fragment = current.doc.createRange();
            fragment.selectNodeContents(element);
            return fragment.comparePoint(range.startContainer, range.startOffset) === 0 || range.comparePoint(element, 0) >= 0;
        });
    }

    if (startIndex < 0) {
        startIndex = clips.findIndex(clip => clip.sectionIndex >= (current?.index ?? 0));
    }

    return clips.map((clip, index) => ({ ...clip, isStart: index === Math.max(0, startIndex) }));
}

export async function highlightNarration(view, target) {
    const resolved = view.resolveNavigation(target);
    if (!resolved) {
        return;
    }

    await view.goTo(target);
    const item = view.renderer.getContents().find(content => content.index === resolved.index);
    const element = item && resolved.anchor?.(item.doc);
    if (!element || typeof element !== 'object' || !item.overlayer) {
        return;
    }

    const range = item.doc.createRange();
    range.selectNodeContents(element);
    return { item, range };
}
