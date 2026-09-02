final class Coordinator: NSObject, ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        // ARKit이 새 앵커를 발견하면 이 함수가 호출됩니다.
    }
}
