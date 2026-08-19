func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    for anchor in anchors {
        guard let imageAnchor = anchor as? ARImageAnchor else {
            continue
        }

        createPortal(on: imageAnchor)
    }
}
