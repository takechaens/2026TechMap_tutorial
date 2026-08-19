guard let imageAnchor = anchor as? ARImageAnchor else {
    return
}

print("포스터 인식 완료: \(imageAnchor.referenceImage.name ?? "이름 없음")")
