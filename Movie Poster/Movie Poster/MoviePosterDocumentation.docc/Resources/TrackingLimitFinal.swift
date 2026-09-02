import SwiftUI
import RealityKit
import ARKit

struct ARViewContainer: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        guard let referenceImages = ARReferenceImage.referenceImages(
            inGroupNamed: "AR Resources", bundle: nil
        ) else { return arView }

        let size = referenceImages.first?.physicalSize ?? .zero
        let width = Float(size.width)
        let height = Float(size.height)
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
