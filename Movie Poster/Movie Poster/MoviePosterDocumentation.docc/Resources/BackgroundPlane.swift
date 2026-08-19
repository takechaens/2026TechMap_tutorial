let backgroundMesh = MeshResource.generatePlane(width: width, depth: height)
let backgroundMaterial = SimpleMaterial(color: .black, isMetallic: false)
let background = ModelEntity(mesh: backgroundMesh, materials: [backgroundMaterial])
anchorEntity.addChild(background)
