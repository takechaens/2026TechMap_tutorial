let videoAspectRatio = videoAspectRatio(for: videoURL)
let posterAspectRatio = width / height

if videoAspectRatio > posterAspectRatio {
    screenWidth = width
    screenHeight = width / videoAspectRatio
} else {
    screenHeight = height
    screenWidth = height * videoAspectRatio
}
