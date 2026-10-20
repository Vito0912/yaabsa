export class ReaderResizeObserver extends globalThis.ResizeObserver {
    #callback;
    #frame = null;
    #pending = new Map();

    constructor(callback) {
        super(entries => {
            for (const entry of entries) {
                this.#pending.set(entry.target, entry);
            }

            if (this.#frame !== null) {
                return;
            }

            this.#frame = requestAnimationFrame(() => {
                this.#frame = null;
                const pending = Array.from(this.#pending.values());
                this.#pending.clear();
                if (pending.length > 0) {
                    this.#callback(pending, this);
                }
            });
        });
        this.#callback = callback;
    }

    #cancelFrame() {
        if (this.#frame !== null) {
            cancelAnimationFrame(this.#frame);
            this.#frame = null;
        }
    }

    unobserve(target) {
        super.unobserve(target);
        this.#pending.delete(target);
        if (this.#pending.size === 0) {
            this.#cancelFrame();
        }
    }

    disconnect() {
        super.disconnect();
        this.#pending.clear();
        this.#cancelFrame();
    }
}
