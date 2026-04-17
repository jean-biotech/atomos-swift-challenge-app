import SceneKit

struct IsometricSceneBuilder {

    static func buildScene() -> SCNScene {
        let scene = SCNScene()
        scene.background.contents = UIColor.clear
        return scene
    }

    static func buildCamera(lookAtY: Float = 5.0) -> SCNNode {
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 8
        camera.zNear = 0.1
        camera.zFar = 100

        let cameraNode = SCNNode()
        cameraNode.name = "isometricCamera"
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(12, 12 + lookAtY, 12)
        cameraNode.look(at: SCNVector3(0, lookAtY, 0))

        return cameraNode
    }

    static func buildLighting() -> [SCNNode] {
        // Ambient fill: soft, no harsh blacks (Monument Valley aesthetic)
        let ambient = SCNNode()
        ambient.name = "ambientLight"
        ambient.light = SCNLight()
        ambient.light!.type = .ambient
        ambient.light!.color = UIColor(white: 0.5, alpha: 1.0)
        ambient.light!.intensity = 600

        // Main directional light: warm white, soft shadows
        let directional = SCNNode()
        directional.name = "directionalLight"
        directional.light = SCNLight()
        directional.light!.type = .directional
        directional.light!.color = UIColor(red: 1.0, green: 0.97, blue: 0.92, alpha: 1.0)
        directional.light!.intensity = 800
        directional.light!.castsShadow = true
        directional.light!.shadowMode = .deferred
        directional.light!.shadowColor = UIColor(white: 0, alpha: 0.12)
        directional.light!.shadowRadius = 8
        directional.light!.shadowSampleCount = 16
        directional.eulerAngles = SCNVector3(-Float.pi / 4, -Float.pi / 6, 0)

        // Subtle fill from the opposite side
        let fill = SCNNode()
        fill.name = "fillLight"
        fill.light = SCNLight()
        fill.light!.type = .directional
        fill.light!.color = UIColor(red: 0.85, green: 0.88, blue: 1.0, alpha: 1.0)
        fill.light!.intensity = 200
        fill.eulerAngles = SCNVector3(-Float.pi / 6, Float.pi / 3, 0)

        return [ambient, directional, fill]
    }

    /// Add ambient floating light motes for Monument Valley atmosphere
    static func buildAmbientParticles(around centerY: Float) -> SCNNode {
        let particleNode = SCNNode()
        particleNode.name = "ambientParticles"

        let particle = SCNParticleSystem()
        particle.particleSize = 0.04
        particle.particleSizeVariation = 0.02
        particle.particleColor = UIColor(white: 1.0, alpha: 0.6)
        particle.particleColorVariation = SCNVector4(0.1, 0.1, 0.2, 0.3)
        particle.birthRate = 8
        particle.particleLifeSpan = 8
        particle.particleLifeSpanVariation = 3
        particle.spreadingAngle = 180
        particle.emittingDirection = SCNVector3(0, 1, 0)
        particle.speedFactor = 0.08
        particle.particleVelocity = 0.05
        particle.particleVelocityVariation = 0.03
        particle.particleAngularVelocity = 20
        particle.particleAngularVelocityVariation = 10
        particle.blendMode = .additive
        particle.isLightingEnabled = false
        particle.emitterShape = SCNBox(width: 6, height: 12, length: 6, chamferRadius: 0)

        particleNode.addParticleSystem(particle)
        particleNode.position = SCNVector3(0, centerY, 0)

        return particleNode
    }

    /// Smoothly move the camera to look at a new target position
    static func animateCamera(_ cameraNode: SCNNode, toLookAt target: SCNVector3, duration: TimeInterval = 1.5) {
        let offset = SCNVector3(12, 12, 12)
        let newPosition = SCNVector3(
            target.x + offset.x,
            target.y + offset.y,
            target.z + offset.z
        )

        let moveAction = SCNAction.move(to: newPosition, duration: duration)
        moveAction.timingMode = .easeInEaseOut

        cameraNode.runAction(moveAction) {
            cameraNode.look(at: target)
        }
    }
}
