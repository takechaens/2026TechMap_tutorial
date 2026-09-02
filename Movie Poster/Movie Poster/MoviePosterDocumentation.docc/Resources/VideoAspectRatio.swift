let videoTrack = AVAsset(url: videoURL)
    .tracks(withMediaType: .video)
    .first

let videoSize = videoTrack?.naturalSize ?? .zero
let videoAspectRatio = videoSize.width / videoSize.height
let posterAspectRatio = width / height
