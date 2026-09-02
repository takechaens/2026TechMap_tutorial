import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        // ARView는 카메라 화면과 3D 콘텐츠를 함께 표시합니다.
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
