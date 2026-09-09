import SwiftUI
import RealityKit
import ARKit

/// SwiftUI 화면 안에 UIKit 기반의 ARView를 넣기 위한 연결 코드입니다.
///
/// SwiftUI는 선언형 UI 프레임워크이고, ARView는 UIKit/RealityKit 객체입니다.
/// UIViewRepresentable을 사용하면 SwiftUI 안에서 ARView를 사용할 수 있습니다.
struct ARViewContainer: UIViewRepresentable {
    // ARView가 화면에 처음 만들어질 때 한 번 호출됩니다.
    func makeUIView(context: Context) -> ARView {
        // 카메라 화면과 RealityKit 콘텐츠를 표시할 ARView를 만듭니다.
        let arView = ARView(frame: .zero)

        // 이미지 추적은 모든 기기에서 지원되는 기능이 아니므로 먼저 확인합니다.
        guard ARImageTrackingConfiguration.isSupported else {
            print("이 기기는 이미지 추적을 지원하지 않습니다.")
            return arView
        }
        return arView
    }

    // SwiftUI 상태가 바뀔 때 호출됩니다.
    // 현재 화면은 ARSession이 직접 관리하므로 별도 업데이트가 필요 없습니다.
    func updateUIView(_ uiView: ARView, context: Context) {}
}
