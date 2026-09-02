func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    for anchor in anchors {
        guard let imageAnchor = anchor as? ARImageAnchor else { continue }
        print("포스터 인식 완료: \(imageAnchor.referenceImage.name ?? "이름 없음")")
        createPortal(on: imageAnchor)
    }
}
