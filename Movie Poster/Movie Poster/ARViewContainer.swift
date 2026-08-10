import SwiftUI
import RealityKit
import ARKit
import AVFoundation

// SwiftUI에서 AR 화면을 쓰기 위한 '포장지' 같은 역할입니다.
struct ARViewContainer: UIViewRepresentable {
    
    // 1. 화면을 처음 그릴 때 호출됩니다.
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero) // 빈 AR 화면 생성
        
        // Coordinator가 AR 화면에 3D 물체를 추가할 수 있도록 arView를 연결해줍니다.
        context.coordinator.arView = arView
        
        // 1. 이미지 추적(Tracking) 설정 시작
        let config = ARImageTrackingConfiguration()
        
        // 2. 우리가 아까 만든 "AR Resources" 그룹에서 이미지들을 가져옵니다.
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("AR Resources 그룹을 찾을 수 없습니다. 이름이 맞는지 확인해주세요!")
        }
        
        // 3. 가져온 이미지들을 추적할 목록에 넣습니다.
        config.trackingImages = referenceImages
        config.maximumNumberOfTrackedImages = 1 // 한 번에 하나만 추적
        
        // 4. AR 화면아, 방금 만든 설정대로 실행(Run)해!
        arView.session.run(config)
        
        // AR 화면의 감시자로 우리가 만든 Coordinator를 지정합니다.
        arView.session.delegate = context.coordinator
        
        return arView
    }
    
    // 2. 화면이 업데이트될 때 호출됩니다. (지금은 비워둡니다)
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    // 감시자(Coordinator)를 만들어내는 함수입니다.
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    // 실제 감시자 역할을 하는 클래스입니다.
    class Coordinator: NSObject, ARSessionDelegate {
        
        // AR 화면을 조종하기 위한 변수
        var arView: ARView?
        // 포털이 여러 개 생기지 않도록 막아주는 장치
        var isPortalAdded = false
        
        var player: AVPlayer?
        
        // 카메라 화면에 새로운 무언가(앵커)가 추가되었을 때 자동으로 실행되는 함수입니다.
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            // 이미 포털을 만들었다면 더 이상 만들지 않고 종료합니다.
            guard !isPortalAdded else { return }
            
            // 발견된 것들 중에 '이미지(포스터)'가 있는지 하나씩 확인합니다.
            for anchor in anchors {
                if let imageAnchor = anchor as? ARImageAnchor {
                    
                    // 포스터를 찾았을 때 디버그 창에 메시지를 띄웁니다.
                    print("🎉 포스터 인식 완료! 포털과 영상을 생성합니다.")
                    
                    // 포털을 만드는 함수를 실행합니다.
                    createPortal(on: imageAnchor)
                    isPortalAdded = true
                }
            }
        }
        // 3D 포털 구멍을 만드는 마법의 함수입니다.
        func createPortal(on imageAnchor: ARImageAnchor) {
            guard let arView = self.arView else { return }
            let anchorEntity = AnchorEntity(anchor: imageAnchor)
            
            let width = Float(imageAnchor.referenceImage.physicalSize.width)
            let height = Float(imageAnchor.referenceImage.physicalSize.height)
            
            // ⭐️ 1. 포털 깊이를 50cm(-0.5)에서 15cm(-0.15)로 얕게 당깁니다.
            let depth: Float = 0.15
            let thickness: Float = 0.1
            
            let occlusionMaterial = OcclusionMaterial()
            
            let leftWall = ModelEntity(mesh: .generateBox(width: thickness, height: height, depth: depth), materials: [occlusionMaterial])
            leftWall.position = [-width/2 - thickness/2, 0, -depth/2]
            
            let rightWall = ModelEntity(mesh: .generateBox(width: thickness, height: height, depth: depth), materials: [occlusionMaterial])
            rightWall.position = [width/2 + thickness/2, 0, -depth/2]
            
            let topWall = ModelEntity(mesh: .generateBox(width: width, height: thickness, depth: depth), materials: [occlusionMaterial])
            topWall.position = [0, height/2 + thickness/2, -depth/2]
            
            let bottomWall = ModelEntity(mesh: .generateBox(width: width, height: thickness, depth: depth), materials: [occlusionMaterial])
            bottomWall.position = [0, -height/2 - thickness/2, -depth/2]
            
            guard let videoURL = Bundle.main.url(forResource: "SpatialTrailer", withExtension: "mov") else { return }
            player = AVPlayer(url: videoURL)
            let videoMaterial = VideoMaterial(avPlayer: player!)
            
            // ⭐️ 2. 문제의 Plane(평면) 대신, 1mm 두께의 아주 얇은 Box(상자)로 스크린을 만듭니다.
            let videoScreen = MeshResource.generateBox(width: width, height: height, depth: 0.001)
            let videoEntity = ModelEntity(mesh: videoScreen, materials: [videoMaterial])
            
            // ⭐️ 3. 비디오 스크린을 포털 맨 안쪽(-0.15)에 배치합니다.
            videoEntity.position.z = -depth
            
            anchorEntity.addChild(leftWall)
            anchorEntity.addChild(rightWall)
            anchorEntity.addChild(topWall)
            anchorEntity.addChild(bottomWall)
            anchorEntity.addChild(videoEntity)
            
            arView.scene.addAnchor(anchorEntity)
            player?.play()
        }
    }
}
