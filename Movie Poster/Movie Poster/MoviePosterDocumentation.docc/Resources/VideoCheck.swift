guard let videoURL else {
    print("영상 파일을 찾지 못했습니다. Target Membership를 확인하세요.")
    return
}

print("포스터 인식 완료")
print("영상 파일 발견: \(videoURL.lastPathComponent)")
print("영상 재생 시작")
