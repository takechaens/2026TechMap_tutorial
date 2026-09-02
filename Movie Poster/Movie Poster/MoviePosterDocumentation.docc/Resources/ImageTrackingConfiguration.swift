guard let referenceImages = ARReferenceImage.referenceImages(
    inGroupNamed: "AR Resources",
    bundle: nil
) else {
    print("참조 이미지를 찾지 못했습니다.")
    return
}

let size = imageAnchor.referenceImage.physicalSize
let width = Float(size.width)
let height = Float(size.height)
let configuration = ARImageTrackingConfiguration()
configuration.trackingImages = referenceImages
