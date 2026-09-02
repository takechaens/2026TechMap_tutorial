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

let leftFrame = makePanel(corners: leftCorners, material: frameMaterial)
let rightFrame = makePanel(corners: rightCorners, material: frameMaterial)
let topFrame = makePanel(corners: topCorners, material: frameMaterial)
let bottomFrame = makePanel(corners: bottomCorners, material: frameMaterial)
anchorEntity.addChild(leftFrame)
anchorEntity.addChild(rightFrame)
anchorEntity.addChild(topFrame)
anchorEntity.addChild(bottomFrame)

let backgroundMesh = MeshResource.generatePlane(width: width, depth: height)
let backgroundMaterial = SimpleMaterial(color: .black, isMetallic: false)
let background = ModelEntity(mesh: backgroundMesh, materials: [backgroundMaterial])
background.position.y = -depth + 0.001
anchorEntity.addChild(background)
    }
}
