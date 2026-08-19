guard let videoURL = Bundle.main.url(
    forResource: "Trailer",
    withExtension: "mov"
) else {
    print("Trailer.mov를 앱 번들에서 찾을 수 없습니다.")
    return
}

let player = AVPlayer(url: videoURL)
let videoMaterial = VideoMaterial(avPlayer: player)
player.play()
