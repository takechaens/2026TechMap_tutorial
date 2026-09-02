guard let videoURL = Bundle.main.url(
    forResource: "토이스토리", withExtension: "mov"
) else { return }

print("토이스토리 영상을 준비했습니다.")
let player = AVPlayer(url: videoURL)
let videoMaterial = VideoMaterial(avPlayer: player)
let screenWidth: Float = 0.16
let screenHeight: Float = 0.09

let mesh = MeshResource.generatePlane(width: screenWidth, depth: screenHeight)
let screen = ModelEntity(mesh: mesh, materials: [videoMaterial])
screen.position.y = -depth + 0.003
anchorEntity.addChild(screen)
