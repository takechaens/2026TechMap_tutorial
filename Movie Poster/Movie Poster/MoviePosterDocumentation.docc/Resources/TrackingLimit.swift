guard let referenceImages = ARReferenceImage.referenceImages(
    inGroupNamed: "AR Resources", bundle: nil
) else {
    return
}

let size = imageAnchor.referenceImage.physicalSize
let width = Float(size.width)
let height = Float(size.height)
let configuration = ARImageTrackingConfiguration()
configuration.trackingImages = referenceImages
configuration.maximumNumberOfTrackedImages = 1
