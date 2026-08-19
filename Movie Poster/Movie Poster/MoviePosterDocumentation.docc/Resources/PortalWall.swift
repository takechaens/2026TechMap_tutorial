let wallMesh = MeshResource.generatePlane(width: width, depth: depth)
let wallMaterial = SimpleMaterial(color: .black, isMetallic: false)
let wall = ModelEntity(mesh: wallMesh, materials: [wallMaterial])
anchorEntity.addChild(wall)
