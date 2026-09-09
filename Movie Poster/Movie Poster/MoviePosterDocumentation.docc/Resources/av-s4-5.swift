import SwiftUI
import RealityKit
import ARKit

/// SwiftUI 화면 안에 UIKit 기반의 ARView를 넣기 위한 연결 코드입니다.
///
/// SwiftUI는 선언형 UI 프레임워크이고, ARView는 UIKit/RealityKit 객체입니다.
/// UIViewRepresentable을 사용하면 SwiftUI 안에서 ARView를 사용할 수 있습니다.
struct ARViewContainer: UIViewRepresentable {
    // Coordinator는 ARSessionDelegate 역할을 담당합니다.
    // SwiftUI가 UIViewRepresentable을 만들 때 이 객체도 함께 생성합니다.
    func makeCoordinator() -> Coordinator { Coordinator() }

    // ARView가 화면에 처음 만들어질 때 한 번 호출됩니다.
    func makeUIView(context: Context) -> ARView {
        // 카메라 화면과 RealityKit 콘텐츠를 표시할 ARView를 만듭니다.
        let arView = ARView(frame: .zero)
        let coordinator = context.coordinator
        coordinator.arView = arView

        // 이미지 추적은 모든 기기에서 지원되는 기능이 아니므로 먼저 확인합니다.
        guard ARImageTrackingConfiguration.isSupported else {
            print("이 기기는 이미지 추적을 지원하지 않습니다.")
            return arView
        }

        // Xcode의 Assets.xcassets 안에 있는
        // 'AR Resources' 그룹에서 참조 이미지를 읽어옵니다.
        // 여기에는 인식할 영화 포스터가 등록되어 있어야 합니다.
        guard let referenceImages = ARReferenceImage.referenceImages(
            inGroupNamed: "AR Resources", bundle: nil
        ) else {
            print("AR Resources 그룹을 찾을 수 없습니다.")
            return arView
        }

        // ARImageTrackingConfiguration은
        // “카메라로 특정 2D 이미지를 찾아 추적하겠다”는 ARKit 설정입니다.
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        // 동시에 추적할 포스터의 최대 개수입니다.
        configuration.maximumNumberOfTrackedImages = 1

        // ARSession은 카메라에서 얻은 AR 정보를 계속 처리합니다.
        // delegate를 통해 이미지가 발견되는 시점을 전달받습니다.
        // 첫 번째 앵커를 놓치지 않도록 run보다 먼저 delegate를 설정합니다.
        arView.session.delegate = coordinator

        // ARSession을 실제로 시작합니다.
        // resetTracking: 이전 추적 정보를 지웁니다.
        // removeExistingAnchors: 이전에 추가한 앵커를 제거합니다.
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        return arView
    }

    // SwiftUI 상태가 바뀔 때 호출됩니다.
    // 현재 화면은 ARSession이 직접 관리하므로 별도 업데이트가 필요 없습니다.
    func updateUIView(_ uiView: ARView, context: Context) {}

    // ARKit 이벤트를 받는 객체입니다.
    final class Coordinator: NSObject, ARSessionDelegate {
        // ARView를 강하게 잡으면 순환 참조가 생길 수 있으므로 weak로 보관합니다.
        weak var arView: ARView?

        // 포스터가 계속 인식될 때 포털이 여러 개 생기는 것을 막습니다.
        private var portalWasAdded = false


        // ARKit이 새로운 앵커를 발견했을 때 호출합니다.
        // ARImageAnchor는 “참조 이미지가 실제 공간에서 발견되었다”는 뜻입니다.
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard !portalWasAdded else { return }

            for anchor in anchors {
                // 여러 종류의 ARAnchor 중에서 이미지 앵커만 사용합니다.
                guard let imageAnchor = anchor as? ARImageAnchor else { continue }
                print("포스터 인식 완료: \(imageAnchor.referenceImage.name ?? "이름 없음")")

                // 이미지 앵커의 위치와 방향을 기준으로 3D 포털을 만듭니다.
                if createPortal(on: imageAnchor) {
                    portalWasAdded = true
                }
                break
            }
        }
    }
}
