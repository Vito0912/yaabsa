import CarPlay
import Flutter
import UIKit

@available(iOS 14.0, *)
@objc class AudioServiceCarPlaySceneDelegate: NSObject, CPTemplateApplicationSceneDelegate {

    private var interfaceController: CPInterfaceController?
    private var handlerChannel: FlutterMethodChannel?

    private var templateForMediaId: [String: CPListTemplate] = [:]
    private let maxTemplateDepth = 4
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

    private func loadChildren(for parentMediaId: String, into template: CPListTemplate) {
        guard let channel = handlerChannel else {
            showError(in: template, message: "Not connected")
            return
        }

        templateForMediaId[parentMediaId] = template

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
                    self.showError(in: template, message: "Failed to load content")
                    return
                }

                let items = childrenRaw.compactMap { self.makeListItem(from: $0) }

                if items.isEmpty {
                    template.emptyViewTitleVariants = ["No content available"]
                    template.updateSections([])
                } else {
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

    private func showError(in template: CPListTemplate, message: String) {
        template.emptyViewTitleVariants = [message]
        template.updateSections([])
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
