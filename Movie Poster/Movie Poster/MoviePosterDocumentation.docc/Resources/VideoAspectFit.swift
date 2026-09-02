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
