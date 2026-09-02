let videoTrack = AVAsset(url: videoURL)
    .tracks(withMediaType: .video)
    .first
let videoSize = videoTrack?.naturalSize ?? .zero
let videoAspectRatio = Float(videoSize.width / videoSize.height)
let posterAspectRatio = width / height
var screenWidth: Float
var screenHeight: Float

if videoAspectRatio > posterAspectRatio {
    screenWidth = width
    screenHeight = width / videoAspectRatio
} else {
    screenHeight = height
    screenWidth = height * videoAspectRatio
}

let backgroundMesh = MeshResource.generatePlane(width: width, depth: height)
let backgroundMaterial = SimpleMaterial(color: .black, isMetallic: false)
let background = ModelEntity(mesh: backgroundMesh, materials: [backgroundMaterial])
background.position.y = -depth + 0.001
anchorEntity.addChild(background)
