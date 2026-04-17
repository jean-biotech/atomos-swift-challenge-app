import SwiftUI
import SceneKit

struct ExplorerSceneView: UIViewRepresentable {
    var explorerState: ExplorerState
    var onNodeTapped: (String) -> Void

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.backgroundColor = .clear
        scnView.antialiasingMode = .multisampling4X
        scnView.autoenablesDefaultLighting = false
        scnView.isJitteringEnabled = false

        // Build scene
        let scene = IsometricSceneBuilder.buildScene()

        // Camera
        let centerY: Float
        switch explorerState.selectedMolecule {
        case .dna: centerY = 5.0
        case .protein: centerY = 4.5
        case .cellMembrane: centerY = 3.0
        case .atp: centerY = 3.0
        case .hemoglobin: centerY = 3.0
        case .water: centerY = 1.5
        case .glucose: centerY = 2.0
        }
        let camera = IsometricSceneBuilder.buildCamera(lookAtY: centerY)
        scene.rootNode.addChildNode(camera)

        // Lighting
        for light in IsometricSceneBuilder.buildLighting() {
            scene.rootNode.addChildNode(light)
        }

        // Build molecule
        let materials = MonumentMaterials.create()
        let moleculeNode: SCNNode

        switch explorerState.selectedMolecule {
        case .dna:
            let data = DNAHelixData.generate(basePairs: 30)
            moleculeNode = DNAHelixSceneBuilder.build(data: data, materials: materials)
        case .protein:
            let data = ProteinStructureData.generateInsulin()
            moleculeNode = ProteinStructureSceneBuilder.build(data: data, materials: materials)
        case .cellMembrane, .atp, .hemoglobin, .water, .glucose:
            moleculeNode = SimpleMoleculeSceneBuilder.build(for: explorerState.selectedMolecule, materials: materials)
        }
        scene.rootNode.addChildNode(moleculeNode)

        // Ambient floating particles
        let particles = IsometricSceneBuilder.buildAmbientParticles(around: centerY)
        scene.rootNode.addChildNode(particles)

        // Character for guided mode
        if explorerState.exploreMode == .guided {
            let character = CharacterNode()
            if let firstStop = explorerState.stops.first {
                character.position = firstStop.position
                character.position.y += 0.3
            }
            scene.rootNode.addChildNode(character)
        }

        scnView.scene = scene
        scnView.pointOfView = camera

        // Camera control
        if explorerState.exploreMode == .free {
            scnView.allowsCameraControl = true
            scnView.defaultCameraController.interactionMode = .orbitTurntable
            scnView.defaultCameraController.maximumVerticalAngle = 80
            scnView.defaultCameraController.minimumVerticalAngle = 10
        } else {
            scnView.allowsCameraControl = false
        }

        // Tap gesture
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)

        context.coordinator.scnView = scnView
        context.coordinator.explorerState = explorerState
        context.coordinator.onNodeTapped = onNodeTapped

        // Add idle rotation for the whole molecule (free mode only;
        // guided mode keeps markers stationary so camera/character/tap alignment is correct)
        if explorerState.exploreMode == .free {
            let rotateAction = SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 60)
            )
            moleculeNode.runAction(rotateAction, forKey: "idleRotation")
        }

        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        context.coordinator.explorerState = explorerState
        context.coordinator.onNodeTapped = onNodeTapped

        // Move character if needed in guided mode
        if explorerState.exploreMode == .guided && explorerState.isCharacterMoving {
            context.coordinator.moveCharacterToCurrentStop()
        }

        // Spotlight the next stop when hint is requested
        if explorerState.hintRequested {
            context.coordinator.spotlightNextStop()
            DispatchQueue.main.async {
                explorerState.hintRequested = false
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {
        weak var scnView: SCNView?
        var explorerState: ExplorerState?
        var onNodeTapped: ((String) -> Void)?
        private var lastMovedStopIndex: Int = -1

        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let scnView = scnView else { return }
            let location = gesture.location(in: scnView)
            let hitResults = scnView.hitTest(location, options: [
                SCNHitTestOption.searchMode: SCNHitTestSearchMode.all.rawValue,
                SCNHitTestOption.boundingBoxOnly: false
            ])

            // Walk all hit results; prefer hotspot markers over other geometry.
            // In guided mode, prefer the hotspot the user can actually visit next.
            var hotspotName: String?
            var visitableHotspot: String?
            var fallbackName: String?

            for hit in hitResults {
                if let name = findRelevantNodeName(hit.node) {
                    if name.hasPrefix("hotspot_") {
                        if hotspotName == nil { hotspotName = name }
                        // In guided mode check if this stop is visitable
                        if visitableHotspot == nil, let state = explorerState,
                           state.exploreMode == .guided,
                           let idx = state.stops.firstIndex(where: { $0.nodeIdentifier == name }),
                           state.canVisitStop(idx) {
                            visitableHotspot = name
                        }
                    }
                    if fallbackName == nil, !name.hasPrefix("hotspot_") {
                        fallbackName = name
                    }
                }
            }

            if let name = visitableHotspot ?? hotspotName ?? fallbackName {
                onNodeTapped?(name)
            }
        }

        private func findRelevantNodeName(_ node: SCNNode) -> String? {
            // Walk up the node hierarchy to find a named node
            var current: SCNNode? = node
            while let n = current {
                if let name = n.name, name.hasPrefix("hotspot_") || name.hasPrefix("basePair_") ||
                    name.hasPrefix("backbone_") || name.hasPrefix("helix_") ||
                    name.hasPrefix("sheet_") || name.hasPrefix("loop_") ||
                    name.hasPrefix("amino_") {
                    return name
                }
                current = n.parent
            }
            return node.name
        }

        func spotlightNextStop() {
            guard let scnView = scnView, let state = explorerState else { return }
            guard let scene = scnView.scene else { return }

            let nextIndex = state.nextUnvisitedStopIndex
            guard nextIndex < state.stops.count else { return }
            let stop = state.stops[nextIndex]

            // Flash the hotspot node 3 times to draw attention
            if let node = scene.rootNode.childNode(withName: stop.nodeIdentifier, recursively: true) {
                let scaleUp = SCNAction.scale(to: 2.8, duration: 0.18)
                scaleUp.timingMode = .easeOut
                let scaleDown = SCNAction.scale(to: 1.0, duration: 0.25)
                scaleDown.timingMode = .easeIn
                let pause = SCNAction.wait(duration: 0.12)
                let flashCycle = SCNAction.sequence([scaleUp, pause, scaleDown, pause])
                node.runAction(SCNAction.repeat(flashCycle, count: 3), forKey: "spotlight")
            }

            // Pan camera toward the next stop
            if let camera = scnView.pointOfView {
                IsometricSceneBuilder.animateCamera(camera, toLookAt: stop.position, duration: 0.9)
            }
        }

        func moveCharacterToCurrentStop() {
            guard let scnView = scnView, let state = explorerState else { return }
            guard let scene = scnView.scene else { return }

            // Guard against duplicate calls from repeated updateUIView invocations
            guard state.currentStopIndex != lastMovedStopIndex else { return }
            lastMovedStopIndex = state.currentStopIndex

            let character = scene.rootNode.childNode(withName: "explorerCharacter", recursively: true)
            guard let char = character else { return }

            let stopIndex = state.currentStopIndex
            guard stopIndex < state.stops.count else { return }
            let stop = state.stops[stopIndex]

            var destination = stop.position
            destination.y += 0.3

            // Animate character walk
            let distance = char.position.distance(to: destination)
            let duration = TimeInterval(max(1.0, distance * 0.5))

            let moveAction = SCNAction.move(to: destination, duration: duration)
            moveAction.timingMode = .easeInEaseOut

            // Bob animation during walk
            let bobUp = SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.2)
            bobUp.timingMode = .easeOut
            let bobDown = SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.2)
            bobDown.timingMode = .easeIn
            let bobCycle = SCNAction.sequence([bobUp, bobDown])
            let bobRepeat = SCNAction.repeat(bobCycle, count: max(1, Int(duration / 0.4)))

            char.runAction(SCNAction.group([moveAction, bobRepeat])) { [weak self] in
                DispatchQueue.main.async {
                    self?.explorerState?.isCharacterMoving = false
                    self?.explorerState?.visitStop(stopIndex)
                    self?.explorerState?.showingInfoCard = true
                    self?.explorerState?.currentInfoContent = stop
                    self?.highlightGeometryForStop(stop)
                }
            }

            // Move camera to follow
            if let camera = scnView.pointOfView {
                IsometricSceneBuilder.animateCamera(camera, toLookAt: stop.position, duration: duration)
            }
        }

        /// Pulse-highlight all visible geometry nodes matching the stop's nodeIdentifier.
        func highlightGeometryForStop(_ stop: EducationalStop) {
            guard let scnView = scnView, let scene = scnView.scene else { return }

            scene.rootNode.enumerateChildNodes { node, _ in
                guard node.name == stop.nodeIdentifier,
                      let mat = node.geometry?.firstMaterial else { return }

                // Scale pulse: grow then return
                let scaleUp = SCNAction.scale(to: 1.45, duration: 0.18)
                scaleUp.timingMode = .easeOut
                let hold = SCNAction.wait(duration: 0.25)
                let scaleDown = SCNAction.scale(to: 1.0, duration: 0.35)
                scaleDown.timingMode = .easeIn
                node.runAction(SCNAction.sequence([scaleUp, hold, scaleDown]),
                               forKey: "visitHighlight")

                // Emission glow: flash teal then fade out
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.15
                mat.emission.contents = UIColor(red: 0.37, green: 0.70, blue: 0.70, alpha: 1) // dnaTeal
                SCNTransaction.completionBlock = {
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.8
                    mat.emission.contents = UIColor.black
                    SCNTransaction.commit()
                }
                SCNTransaction.commit()
            }
        }
    }
}

// MARK: - SCNVector3 distance helper
extension SCNVector3 {
    func distance(to other: SCNVector3) -> Float {
        let dx = x - other.x
        let dy = y - other.y
        let dz = z - other.z
        return sqrt(dx * dx + dy * dy + dz * dz)
    }
}
