private var portalWasAdded = false

func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
    guard !portalWasAdded else { return }
    for anchor in anchors {
        guard let imageAnchor = anchor as? ARImageAnchor else { continue }
        print("포스터 인식 완료: \(imageAnchor.referenceImage.name ?? \"이름 없음\")")
        createPortal(on: imageAnchor)
        portalWasAdded = true
        let anchorEntity = AnchorEntity(anchor: imageAnchor)
        arView.scene.addAnchor(anchorEntity)
        let size = imageAnchor.referenceImage.physicalSize
        let width = Float(size.width)
        let height = Float(size.height)
        let depth: Float = 0.20
        let flare: Float = 0.10
        let backY = -depth
        let frontY: Float = 0
        let frameMaterial = SimpleMaterial(color: .black, isMetallic: false)
        let backHalfWidth = width / 2
        let backHalfHeight = height / 2
        let frontHalfWidth = backHalfWidth + flare
        let frontHalfHeight = backHalfHeight + flare

let leftFrame = makePanel(corners: leftCorners, material: frameMaterial)
let rightFrame = makePanel(corners: rightCorners, material: frameMaterial)
let topFrame = makePanel(corners: topCorners, material: frameMaterial)
let bottomFrame = makePanel(corners: bottomCorners, material: frameMaterial)

anchorEntity.addChild(leftFrame)
anchorEntity.addChild(rightFrame)
anchorEntity.addChild(topFrame)
        anchorEntity.addChild(bottomFrame)
    }
}
