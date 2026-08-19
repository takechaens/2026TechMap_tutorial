arView.session.delegate = context.coordinator
arView.session.run(
    configuration,
    options: [.resetTracking, .removeExistingAnchors]
)
