import SceneKit

class CharacterNode: SCNNode {

    private let bodyNode: SCNNode
    private let headNode: SCNNode
    private let hatNode: SCNNode

    override init() {
        // Body: small cone (like Monument Valley's Ida / chess pawn)
        let body = SCNCone(topRadius: 0.0, bottomRadius: 0.15, height: 0.35)
        body.radialSegmentCount = 16
        let bodyMaterial = SCNMaterial()
        bodyMaterial.lightingModel = .physicallyBased
        bodyMaterial.diffuse.contents = UIColor.white
        bodyMaterial.emission.contents = UIColor(white: 1.0, alpha: 0.2)
        bodyMaterial.emission.intensity = 0.3
        bodyMaterial.roughness.contents = NSNumber(value: 0.4)
        bodyMaterial.metalness.contents = NSNumber(value: 0.0)
        body.firstMaterial = bodyMaterial
        bodyNode = SCNNode(geometry: body)
        bodyNode.position = SCNVector3(0, 0.175, 0)

        // Head: small sphere
        let head = SCNSphere(radius: 0.1)
        head.segmentCount = 16
        let headMaterial = SCNMaterial()
        headMaterial.lightingModel = .physicallyBased
        headMaterial.diffuse.contents = UIColor.white
        headMaterial.roughness.contents = NSNumber(value: 0.3)
        headMaterial.metalness.contents = NSNumber(value: 0.0)
        head.firstMaterial = headMaterial
        headNode = SCNNode(geometry: head)
        headNode.position = SCNVector3(0, 0.45, 0)

        // Pointed hat (like Monument Valley's princess hat)
        let hat = SCNCone(topRadius: 0.0, bottomRadius: 0.08, height: 0.15)
        hat.radialSegmentCount = 12
        let hatMaterial = SCNMaterial()
        hatMaterial.lightingModel = .physicallyBased
        hatMaterial.diffuse.contents = UIColor(red: 1.0, green: 0.82, blue: 0.75, alpha: 1.0)  // monumentPeach
        hatMaterial.roughness.contents = NSNumber(value: 0.5)
        hatMaterial.metalness.contents = NSNumber(value: 0.0)
        hat.firstMaterial = hatMaterial
        hatNode = SCNNode(geometry: hat)
        hatNode.position = SCNVector3(0, 0.58, 0)

        super.init()

        name = "explorerCharacter"
        addChildNode(bodyNode)
        addChildNode(headNode)
        addChildNode(hatNode)

        // Gentle idle bob
        let bobUp = SCNAction.moveBy(x: 0, y: 0.03, z: 0, duration: 1.5)
        bobUp.timingMode = .easeInEaseOut
        let bobDown = SCNAction.moveBy(x: 0, y: -0.03, z: 0, duration: 1.5)
        bobDown.timingMode = .easeInEaseOut
        let idleBob = SCNAction.repeatForever(SCNAction.sequence([bobUp, bobDown]))
        runAction(idleBob, forKey: "idleBob")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func animateWalk(to destination: SCNVector3, duration: TimeInterval, completion: @escaping () -> Void) {
        // Stop idle bob during walk
        removeAction(forKey: "idleBob")

        // Face direction of travel
        let dx = destination.x - position.x
        let dz = destination.z - position.z
        let targetAngle = atan2(dx, dz)

        let rotateAction = SCNAction.rotateTo(x: 0, y: CGFloat(targetAngle), z: 0, duration: 0.3)
        rotateAction.timingMode = .easeInEaseOut

        let moveAction = SCNAction.move(to: destination, duration: duration)
        moveAction.timingMode = .easeInEaseOut

        // Walk bob (faster than idle)
        let walkBobUp = SCNAction.moveBy(x: 0, y: 0.06, z: 0, duration: 0.18)
        walkBobUp.timingMode = .easeOut
        let walkBobDown = SCNAction.moveBy(x: 0, y: -0.06, z: 0, duration: 0.18)
        walkBobDown.timingMode = .easeIn
        let walkBob = SCNAction.sequence([walkBobUp, walkBobDown])
        let walkBobRepeat = SCNAction.repeat(walkBob, count: max(1, Int(duration / 0.36)))

        let walkSequence = SCNAction.sequence([rotateAction, SCNAction.group([moveAction, walkBobRepeat])])

        runAction(walkSequence) { [weak self] in
            // Resume idle bob
            let bobUp = SCNAction.moveBy(x: 0, y: 0.03, z: 0, duration: 1.5)
            bobUp.timingMode = .easeInEaseOut
            let bobDown = SCNAction.moveBy(x: 0, y: -0.03, z: 0, duration: 1.5)
            bobDown.timingMode = .easeInEaseOut
            let idleBob = SCNAction.repeatForever(SCNAction.sequence([bobUp, bobDown]))
            self?.runAction(idleBob, forKey: "idleBob")

            completion()
        }
    }
}
