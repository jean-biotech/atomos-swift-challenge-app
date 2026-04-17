import SceneKit
import SwiftUI

struct DNAHelixSceneBuilder {

    static func build(data: DNAHelixData, materials: MonumentMaterials) -> SCNNode {
        let rootNode = SCNNode()
        rootNode.name = "dnaHelix"

        // 1. Sugar-phosphate backbones as spiral staircases
        let backbone1 = buildBackboneSpiral(strand: 0, data: data, material: materials.backboneTeal)
        let backbone2 = buildBackboneSpiral(strand: 1, data: data, material: materials.backbonePink)
        rootNode.addChildNode(backbone1)
        rootNode.addChildNode(backbone2)

        // 2. Base pair bridges connecting the two strands
        for nucleotide in data.nucleotides {
            let bridge = buildBasePairBridge(nucleotide: nucleotide, materials: materials)
            rootNode.addChildNode(bridge)
        }

        // 3. Decorative platform at the base
        let basePlatform = buildBasePlatform(radius: data.backboneRadius, materials: materials)
        rootNode.addChildNode(basePlatform)

        // 4. Decorative cap at the top
        let topY = Float(data.totalBasePairs) * data.risePerBasePair
        let topCap = buildTopCap(y: topY, radius: data.backboneRadius, materials: materials)
        rootNode.addChildNode(topCap)

        // 5. Hotspot markers for educational stops
        let stops = DNAEducationalContent.stops
        for stop in stops {
            let marker = buildHotspotMarker(at: stop.position, material: materials.hotspotGlow)
            marker.name = stop.nodeIdentifier
            rootNode.addChildNode(marker)
        }

        return rootNode
    }

    // MARK: - Backbone Spiral

    private static func buildBackboneSpiral(strand: Int, data: DNAHelixData, material: SCNMaterial) -> SCNNode {
        let spineNode = SCNNode()
        spineNode.name = "backbone_\(strand)"

        let phaseOffset: Float = strand == 0 ? 0 : Float.pi
        let segmentCount = data.totalBasePairs

        var previousPosition: SCNVector3?

        for i in 0..<segmentCount {
            let angle = Float(i) * (2.0 * Float.pi / Float(data.basePairsPerTurn)) + phaseOffset
            let y = Float(i) * data.risePerBasePair
            let x = data.backboneRadius * cos(angle)
            let z = data.backboneRadius * sin(angle)
            let position = SCNVector3(x, y, z)

            // Joint sphere — like balustrade posts on a spiral staircase
            let jointRadius: CGFloat = 0.12
            let sphere = SCNSphere(radius: jointRadius)
            sphere.segmentCount = 16
            sphere.firstMaterial = material
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.position = position
            spineNode.addChildNode(sphereNode)

            // Cylinder railing connecting to previous joint
            if let prev = previousPosition {
                let cylinder = createCylinderBetween(from: prev, to: position, radius: 0.06, material: material)
                spineNode.addChildNode(cylinder)
            }

            // Add small decorative step platforms every 3 base pairs
            if i % 3 == 0 {
                let step = SCNBox(width: 0.35, height: 0.04, length: 0.2, chamferRadius: 0.01)
                step.firstMaterial = material
                let stepNode = SCNNode(geometry: step)
                stepNode.position = position
                // Orient step to face outward from helix center
                let outwardAngle = angle + (strand == 0 ? Float.pi / 2 : -Float.pi / 2)
                stepNode.eulerAngles.y = outwardAngle
                spineNode.addChildNode(stepNode)
            }

            previousPosition = position
        }

        return spineNode
    }

    // MARK: - Base Pair Bridges

    private static func buildBasePairBridge(nucleotide: NucleotideData, materials: MonumentMaterials) -> SCNNode {
        let bridgeNode = SCNNode()
        bridgeNode.name = "basePair_\(nucleotide.id)"

        let from = nucleotide.position
        let to = nucleotide.complementPosition

        // Calculate distance and midpoint
        let dx = to.x - from.x
        let dy = to.y - from.y
        let dz = to.z - from.z
        let distance = sqrt(dx * dx + dy * dy + dz * dz)

        // Bridge platform
        let bridgeWidth: CGFloat = CGFloat(distance) * 0.85
        let bridge = SCNBox(width: bridgeWidth, height: 0.06, length: 0.22, chamferRadius: 0.02)

        let material: SCNMaterial
        switch nucleotide.basePair {
        case .AT, .TA:
            material = materials.basePairGold
        case .GC, .CG:
            material = materials.basePairTeal
        }
        bridge.firstMaterial = material

        let bridgeMesh = SCNNode(geometry: bridge)

        // Position at midpoint
        let midX = (from.x + to.x) / 2
        let midY = (from.y + to.y) / 2
        let midZ = (from.z + to.z) / 2
        bridgeNode.position = SCNVector3(midX, midY, midZ)

        // Rotate to face from strand 1 to strand 2
        let angle = atan2(dz, dx)
        bridgeNode.eulerAngles.y = -angle

        bridgeNode.addChildNode(bridgeMesh)

        // Small colored spheres at each end representing the actual bases
        let baseRadius: CGFloat = 0.08
        let base1 = SCNSphere(radius: baseRadius)
        base1.segmentCount = 12
        base1.firstMaterial = MonumentMaterials.aminoAcidMaterial(for: nucleotide.basePair.primaryColor)
        let base1Node = SCNNode(geometry: base1)
        base1Node.position = SCNVector3(-Float(bridgeWidth) / 2 + 0.1, 0.05, 0)
        bridgeNode.addChildNode(base1Node)

        let base2 = SCNSphere(radius: baseRadius)
        base2.segmentCount = 12
        base2.firstMaterial = MonumentMaterials.aminoAcidMaterial(for: nucleotide.basePair.secondaryColor)
        let base2Node = SCNNode(geometry: base2)
        base2Node.position = SCNVector3(Float(bridgeWidth) / 2 - 0.1, 0.05, 0)
        bridgeNode.addChildNode(base2Node)

        return bridgeNode
    }

    // MARK: - Decorative Elements

    private static func buildBasePlatform(radius: Float, materials: MonumentMaterials) -> SCNNode {
        let platformNode = SCNNode()
        platformNode.name = "basePlatform"

        // Circular base platform
        let platform = SCNCylinder(radius: CGFloat(radius + 0.8), height: 0.15)
        platform.radialSegmentCount = 32
        platform.firstMaterial = materials.backboneTeal
        let platformMesh = SCNNode(geometry: platform)
        platformMesh.position = SCNVector3(0, -0.1, 0)
        platformNode.addChildNode(platformMesh)

        // Decorative ring
        let ring = SCNTorus(ringRadius: CGFloat(radius + 0.5), pipeRadius: 0.05)
        ring.firstMaterial = materials.basePairGold
        let ringNode = SCNNode(geometry: ring)
        ringNode.position = SCNVector3(0, 0.0, 0)
        platformNode.addChildNode(ringNode)

        return platformNode
    }

    private static func buildTopCap(y: Float, radius: Float, materials: MonumentMaterials) -> SCNNode {
        let capNode = SCNNode()
        capNode.name = "topCap"

        // Pyramid-like cap (Monument Valley tower top)
        let pyramid = SCNPyramid(width: CGFloat(radius * 1.2), height: 0.8, length: CGFloat(radius * 1.2))
        pyramid.firstMaterial = materials.basePairGold
        let pyramidNode = SCNNode(geometry: pyramid)
        pyramidNode.position = SCNVector3(0, y + 0.2, 0)
        capNode.addChildNode(pyramidNode)

        // Small sphere finial on top
        let finial = SCNSphere(radius: 0.12)
        finial.firstMaterial = materials.hotspotGlow
        let finialNode = SCNNode(geometry: finial)
        finialNode.position = SCNVector3(0, y + 1.1, 0)
        capNode.addChildNode(finialNode)

        return capNode
    }

    // MARK: - Hotspot Markers

    private static func buildHotspotMarker(at position: SCNVector3, material: SCNMaterial) -> SCNNode {
        let markerNode = SCNNode()

        // Glowing sphere
        let sphere = SCNSphere(radius: 0.18)
        sphere.segmentCount = 24
        sphere.firstMaterial = material
        let sphereNode = SCNNode(geometry: sphere)
        markerNode.addChildNode(sphereNode)

        // Outer ring indicator
        let ring = SCNTorus(ringRadius: 0.3, pipeRadius: 0.025)
        ring.firstMaterial = material
        let ringNode = SCNNode(geometry: ring)
        ringNode.eulerAngles.x = Float.pi / 2
        markerNode.addChildNode(ringNode)

        markerNode.position = position

        // Pulse animation
        let scaleUp = SCNAction.scale(to: 1.2, duration: 1.0)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SCNAction.scale(to: 1.0, duration: 1.0)
        scaleDown.timingMode = .easeInEaseOut
        let pulse = SCNAction.repeatForever(SCNAction.sequence([scaleUp, scaleDown]))
        markerNode.runAction(pulse)

        // Slow rotation on the ring
        let rotate = SCNAction.repeatForever(
            SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 4.0)
        )
        ringNode.runAction(rotate)

        return markerNode
    }

    // MARK: - Utility

    private static func createCylinderBetween(from: SCNVector3, to: SCNVector3, radius: Float, material: SCNMaterial) -> SCNNode {
        let dx = to.x - from.x
        let dy = to.y - from.y
        let dz = to.z - from.z
        let distance = sqrt(dx * dx + dy * dy + dz * dz)

        let cylinder = SCNCylinder(radius: CGFloat(radius), height: CGFloat(distance))
        cylinder.radialSegmentCount = 12
        cylinder.firstMaterial = material

        let node = SCNNode(geometry: cylinder)

        // Position at midpoint
        node.position = SCNVector3(
            (from.x + to.x) / 2,
            (from.y + to.y) / 2,
            (from.z + to.z) / 2
        )

        // Orient cylinder to point from `from` to `to`
        let direction = SCNVector3(dx, dy, dz)
        let up = SCNVector3(0, 1, 0)

        // Compute rotation axis and angle
        let cross = SCNVector3(
            up.y * direction.z - up.z * direction.y,
            up.z * direction.x - up.x * direction.z,
            up.x * direction.y - up.y * direction.x
        )
        let crossLength = sqrt(cross.x * cross.x + cross.y * cross.y + cross.z * cross.z)
        let dot = up.x * direction.x + up.y * direction.y + up.z * direction.z

        if crossLength > 0.0001 {
            let angle = atan2(crossLength, dot)
            let axis = SCNVector3(cross.x / crossLength, cross.y / crossLength, cross.z / crossLength)
            node.rotation = SCNVector4(axis.x, axis.y, axis.z, angle)
        } else if dot < 0 {
            // Opposite direction — rotate 180 around any perpendicular axis
            node.rotation = SCNVector4(1, 0, 0, Float.pi)
        }

        return node
    }
}
