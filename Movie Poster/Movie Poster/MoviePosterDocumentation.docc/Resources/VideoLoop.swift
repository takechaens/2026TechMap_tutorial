NotificationCenter.default.addObserver(
    forName: .AVPlayerItemDidPlayToEndTime,
    object: player.currentItem,
    queue: .main
) { _ in
    player.seek(to: .zero)
    player.play()
}
