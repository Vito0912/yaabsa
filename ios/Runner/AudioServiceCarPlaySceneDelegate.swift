import CarPlay
import Flutter
import UIKit

@available(iOS 14.0, *)
@objc class AudioServiceCarPlaySceneDelegate: NSObject, CPTemplateApplicationSceneDelegate {

    private var interfaceController: CPInterfaceController?
    private var handlerChannel: FlutterMethodChannel?

    private var templateForMediaId: [String: CPListTemplate] = [:]
    private let maxTemplateDepth = 5
    private let maxContentLoadAttempts = 5
    private let contentLoadRetryDelay: TimeInterval = 1
    private let nowPlayingPushDebounceSeconds: TimeInterval = 0.6
    private var lastNowPlayingPushAt: TimeInterval = 0

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didConnect interfaceController: CPInterfaceController
    ) {
        self.interfaceController = interfaceController
        self.handlerChannel = makeHandlerChannel()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onChildrenChanged(_:)),
            name: Notification.Name("AudioServiceChildrenChangedNotification"),
            object: nil
        )

        let rootTemplate = makeLoadingTemplate(title: "Yaabsa")
        interfaceController.setRootTemplate(rootTemplate, animated: false, completion: nil)
        loadChildren(for: "root", into: rootTemplate)
    }

    func templateApplicationScene(
        _ templateApplicationScene: CPTemplateApplicationScene,
        didDisconnectInterfaceController interfaceController: CPInterfaceController
    ) {
        NotificationCenter.default.removeObserver(self)
        self.interfaceController = nil
        self.handlerChannel = nil
        self.templateForMediaId.removeAll()
    }

    private func makeHandlerChannel() -> FlutterMethodChannel? {
        guard let messenger = findFlutterBinaryMessenger() else { return nil }
        return FlutterMethodChannel(
            name: "com.ryanheise.audio_service.handler.methods",
            binaryMessenger: messenger
        )
    }

    private func findFlutterBinaryMessenger() -> FlutterBinaryMessenger? {
        return sharedFlutterEngine.binaryMessenger
    }

    private func makeLoadingTemplate(title: String) -> CPListTemplate {
        let template = CPListTemplate(title: title, sections: [])
        if #available(iOS 18.4, *) {
            template.showsSpinnerWhileEmpty = true
        }
        return template
    }

    private func canPushTemplate(_ template: CPTemplate, on interfaceController: CPInterfaceController) -> Bool {
        if interfaceController.templates.contains(where: { $0 === template }) {
            return false
        }
        return interfaceController.templates.count < maxTemplateDepth
    }

    private func loadChildren(for parentMediaId: String, into template: CPListTemplate, attempt: Int = 0) {
        guard let channel = handlerChannel else {
            showError(in: template, parentMediaId: parentMediaId, message: "CarPlay is not connected")
            return
        }

        templateForMediaId[parentMediaId] = template
        setLoading(true, in: template)

        channel.invokeMethod(
            "getChildren",
            arguments: ["parentMediaId": parentMediaId]
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                guard
                    let resultDict = result as? [String: Any],
                    let childrenRaw = resultDict["children"] as? [[String: Any]]
                else {
                    self.retryOrShowError(
                        for: parentMediaId,
                        in: template,
                        attempt: attempt,
                        message: "Couldn't load content",
                    )
                    return
                }

                let items = childrenRaw.compactMap { self.makeListItem(from: $0) }

                if items.isEmpty {
                    if attempt < self.maxContentLoadAttempts {
                        self.retryLoad(for: parentMediaId, in: template, attempt: attempt)
                        return
                    }
                    self.showEmptyState(in: template)
                } else {
                    self.setLoading(false, in: template)
                    template.emptyViewTitleVariants = []
                    let limit = CPListTemplate.maximumItemCount
                    let capped = items.count > limit ? Array(items.prefix(limit)) : items
                    template.updateSections([CPListSection(items: capped)])
                }
            }
        }
    }

    private func makeListItem(from map: [String: Any]) -> CPListItem? {
        guard let title = map["title"] as? String else { return nil }

        let subtitle = (map["displaySubtitle"] as? String)
                    ?? (map["artist"] as? String)

        let isPlayable = (map["playable"] as? Bool) ?? true
        let mediaId    = (map["id"] as? String) ?? ""

        let item = CPListItem(text: title, detailText: subtitle)

        if isPlayable {
            item.handler = { [weak self] _, completion in
                self?.handlePlayableItemSelected(mediaId: mediaId)
                completion()
            }
        } else {
            item.accessoryType = .disclosureIndicator
            item.handler = { [weak self] _, completion in
                self?.handleBrowsableItemSelected(mediaId: mediaId, title: title)
                completion()
            }
        }

        return item
    }

    private func handlePlayableItemSelected(mediaId: String) {
        guard let channel = handlerChannel,
              let ic = interfaceController else { return }

        channel.invokeMethod("playFromMediaId", arguments: ["mediaId": mediaId], result: nil)

        let now = CFAbsoluteTimeGetCurrent()
        if now - lastNowPlayingPushAt < nowPlayingPushDebounceSeconds {
            return
        }
        lastNowPlayingPushAt = now

        let nowPlayingTemplate = CPNowPlayingTemplate.shared
        guard canPushTemplate(nowPlayingTemplate, on: ic) else { return }
        ic.pushTemplate(nowPlayingTemplate, animated: true, completion: nil)
    }

    private func handleBrowsableItemSelected(mediaId: String, title: String) {
        guard let ic = interfaceController else { return }

        if let existing = templateForMediaId[mediaId] {
            loadChildren(for: mediaId, into: existing)
            guard canPushTemplate(existing, on: ic) else { return }
            ic.pushTemplate(existing, animated: true, completion: nil)
            return
        }

        let childTemplate = makeLoadingTemplate(title: title)
        guard canPushTemplate(childTemplate, on: ic) else { return }
        ic.pushTemplate(childTemplate, animated: true, completion: nil)
        loadChildren(for: mediaId, into: childTemplate)
    }

    @objc private func onChildrenChanged(_ notification: Notification) {
        guard
            let parentMediaId = notification.userInfo?["parentMediaId"] as? String,
            let template = templateForMediaId[parentMediaId]
        else { return }

        loadChildren(for: parentMediaId, into: template)
    }

    private func retryOrShowError(
        for parentMediaId: String,
        in template: CPListTemplate,
        attempt: Int,
        message: String,
    ) {
        if attempt < maxContentLoadAttempts {
            retryLoad(for: parentMediaId, in: template, attempt: attempt)
            return
        }

        showError(in: template, parentMediaId: parentMediaId, message: message)
    }

    private func retryLoad(for parentMediaId: String, in template: CPListTemplate, attempt: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + contentLoadRetryDelay) { [weak self] in
            self?.loadChildren(for: parentMediaId, into: template, attempt: attempt + 1)
        }
    }

    private func setLoading(_ isLoading: Bool, in template: CPListTemplate) {
        if #available(iOS 18.4, *) {
            template.showsSpinnerWhileEmpty = isLoading
        }
    }

    private func showEmptyState(in template: CPListTemplate) {
        setLoading(false, in: template)
        template.emptyViewTitleVariants = ["No content available"]
        template.updateSections([])
    }

    private func showError(in template: CPListTemplate, parentMediaId: String, message: String) {
        setLoading(false, in: template)
        let retryItem = CPListItem(text: message, detailText: "Select to retry")
        retryItem.handler = { [weak self] _, completion in
            self?.loadChildren(for: parentMediaId, into: template)
            completion()
        }
        template.emptyViewTitleVariants = []
        template.updateSections([CPListSection(items: [retryItem])])
    }

    private func fetchArtwork(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if url.isFileURL {
            DispatchQueue.global(qos: .utility).async {
                let image = UIImage(contentsOfFile: url.path)
                DispatchQueue.main.async { completion(image) }
            }
            return
        }

        guard url.scheme == "http" || url.scheme == "https" else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            let image = data.flatMap { UIImage(data: $0) }
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }

    private func resizeImageIfNeeded(_ image: UIImage, maxSize: CGSize) -> UIImage {
        let w = image.size.width
        let h = image.size.height
        guard w > maxSize.width || h > maxSize.height else { return image }
        let scale = min(maxSize.width / w, maxSize.height / h)
        let newSize = CGSize(width: w * scale, height: h * scale)
        let renderer = UIGraphicsImageRenderer(size: newSize)
        return renderer.image { _ in image.draw(in: CGRect(origin: .zero, size: newSize)) }
    }
}
