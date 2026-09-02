guard let referenceImages = ARReferenceImage.referenceImages(
    inGroupNamed: "AR Resources",
    bundle: nil
) else {
    return
}

// 다음 단계에서 사용할 실제 포스터 크기입니다.
let size = imageAnchor.referenceImage.physicalSize
let width = Float(size.width)
let height = Float(size.height)
