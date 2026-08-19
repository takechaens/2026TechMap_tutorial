guard let videoURL = Bundle.main.url(
    forResource: "Trailer",
    withExtension: "mov"
) else {
    print("Trailer.mov를 찾지 못했습니다.")
    return
}
