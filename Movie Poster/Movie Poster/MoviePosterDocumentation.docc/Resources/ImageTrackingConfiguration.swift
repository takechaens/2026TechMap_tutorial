guard let referenceImages = ARReferenceImage.referenceImages(
    inGroupNamed: "AR Resources",
    bundle: nil
) else {
    print("AR Resources 그룹을 찾을 수 없습니다.")
    return
}

let configuration = ARImageTrackingConfiguration()
configuration.trackingImages = referenceImages
configuration.maximumNumberOfTrackedImages = 1
