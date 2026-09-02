final class Coordinator: NSObject, ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        // ARKit이 새 앵커를 발견하면 이 함수가 호출됩니다.
        for anchor in anchors {
            guard let imageAnchor = anchor as? ARImageAnchor else { continue }
            print("포스터 인식 완료: \(imageAnchor.referenceImage.name ?? "이름 없음")")
            createPortal(on: imageAnchor)
        }
    }
}
