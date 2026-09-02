guard let videoURL = Bundle.main.url(
    forResource: "토이스토리",
    withExtension: "mov"
) else {
    print("토이스토리.mov를 앱 번들에서 찾을 수 없습니다.")
    return
}

let player = AVPlayer(url: videoURL)
let videoMaterial = VideoMaterial(avPlayer: player)
let screenWidth: Float = 0.16
let screenHeight: Float = 0.09
