guard let videoURL = Bundle.main.url(
    forResource: "토이스토리",
    withExtension: "mov"
) else {
    print("토이스토리.mov를 찾지 못했습니다.")
    return
}
