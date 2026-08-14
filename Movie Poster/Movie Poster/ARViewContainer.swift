import SwiftUI
import RealityKit
import ARKit
import AVFoundation

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

        // AVPlayer가 지역 변수로 사라지지 않도록 프로퍼티로 보관합니다.
        // AVPlayer가 해제되면 영상도 재생되지 않을 수 있습니다.
        private var player: AVPlayer?

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

        @discardableResult
        /// 이미지 앵커에 영상 화면과 포털 프레임을 추가합니다.
        /// 반환값은 포털 생성에 성공했는지 여부입니다.
        private func createPortal(on imageAnchor: ARImageAnchor) -> Bool {
            guard let arView else { return false }

            // 일반 2D 영상만 사용합니다.
            // Spatial Video는 좌우 시점 정보가 포함될 수 있으므로
            // 현재 학습 단계에서는 단일 화면 Video를 사용합니다.
            let videoURL = Bundle.main.url(forResource: "Trailer", withExtension: "mov")

            guard let videoURL else {
                print("Trailer.mov를 앱 번들에서 찾을 수 없습니다. Target Membership를 확인하세요.")
                return false
            }
            print("영상 파일 발견: \(videoURL.lastPathComponent)")

            // 참조 이미지에 설정한 실제 물리 크기입니다.
            // 이 값이 있어야 포스터의 실제 크기에 맞춰 3D 객체를 배치할 수 있습니다.
            let size = imageAnchor.referenceImage.physicalSize
            let width = Float(size.width)
            let height = Float(size.height)

            // RealityKit의 카메라 기준으로 음수 z 방향은 포스터 안쪽입니다.
            // 따라서 영상 화면을 -0.15m 뒤로 보내 깊이감을 만듭니다.
            let depth: Float = 0.15

            // 포털 가장자리에 보이는 검은색 프레임의 두께입니다.
            let frameThickness: Float = 0.012

            // AnchorEntity는 ARImageAnchor의 위치·회전·추적 상태를 따라갑니다.
            // 여기에 자식 Entity를 넣으면 포스터에 붙어 있는 것처럼 움직입니다.
            let anchorEntity = AnchorEntity(anchor: imageAnchor)

            // OcclusionMaterial은 물체를 “보이지 않게 가리는” 용도입니다.
            // 학습 단계에서 포털 테두리를 눈으로 확인할 수 있도록
            // 여기서는 검은색 SimpleMaterial을 사용합니다.
            let frameMaterial = SimpleMaterial(color: .black, isMetallic: false)
            let leftFrame = makeBox(width: frameThickness, height: height, depth: depth,
                                    position: [-width / 2 - frameThickness / 2, 0, -depth / 2],
                                    material: frameMaterial)
            let rightFrame = makeBox(width: frameThickness, height: height, depth: depth,
                                     position: [width / 2 + frameThickness / 2, 0, -depth / 2],
                                     material: frameMaterial)
            let topFrame = makeBox(width: width, height: frameThickness, depth: depth,
                                   position: [0, height / 2 + frameThickness / 2, -depth / 2],
                                   material: frameMaterial)
            let bottomFrame = makeBox(width: width, height: frameThickness, depth: depth,
                                      position: [0, -height / 2 - frameThickness / 2, -depth / 2],
                                      material: frameMaterial)

            // AVPlayer는 영상 파일을 읽고 재생하는 객체입니다.
            let avPlayer = AVPlayer(url: videoURL)

            // VideoMaterial은 AVPlayer의 영상을 RealityKit 3D 표면의 재질로 사용합니다.
            // 즉, 별도의 UIImage나 텍스처 변환 없이 영상이 ModelEntity에 표시됩니다.
            let videoMaterial = VideoMaterial(avPlayer: avPlayer)

            // 영상은 3D 상자가 아니라 세로로 세운 평면 하나에만 표시해야 합니다.
            // Box를 사용하면 VideoMaterial이 6개 면에 모두 적용됩니다.
            // 그 결과 휴대폰을 아래에서 위로 기울였을 때 상단 면이 천장처럼 보입니다.
            // generatePlane은 기본적으로 바닥을 향하므로 x축으로 90도 회전시켜 세웁니다.
            let videoMesh = MeshResource.generatePlane(width: width, depth: height)
            let videoEntity = ModelEntity(mesh: videoMesh, materials: [videoMaterial])
            videoEntity.orientation = simd_quatf(
                angle: .pi / 2,
                axis: SIMD3<Float>(1, 0, 0)
            )

            // 영상 평면을 포스터 안쪽으로 이동합니다.
            videoEntity.position.z = -depth

            // 프레임과 영상 화면을 포털 앵커의 자식으로 연결합니다.
            anchorEntity.addChild(leftFrame)
            anchorEntity.addChild(rightFrame)
            anchorEntity.addChild(topFrame)
            anchorEntity.addChild(bottomFrame)
            anchorEntity.addChild(videoEntity)

            // 만든 앵커를 RealityKit 장면에 추가해야 실제 화면에 렌더링됩니다.
            arView.scene.addAnchor(anchorEntity)

            // 플레이어를 프로퍼티에 보관한 뒤 재생합니다.
            player = avPlayer
            avPlayer.play()
            print("영상 재생 시작")
            return true
        }

        // 프레임을 만드는 반복 코드를 줄이기 위한 보조 함수입니다.
        private func makeBox(width: Float, height: Float, depth: Float,
                             position: SIMD3<Float>, material: SimpleMaterial) -> ModelEntity {
            let mesh = MeshResource.generateBox(width: width, height: height, depth: depth)
            let entity = ModelEntity(mesh: mesh, materials: [material])
            entity.position = position
            return entity
        }
    }
}
