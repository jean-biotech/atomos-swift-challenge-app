import SceneKit
import SwiftUI

struct ProteinStructureSceneBuilder {

    static func build(data: ProteinStructureData, materials: MonumentMaterials) -> SCNNode {
        let rootNode = SCNNode()
        rootNode.name = "proteinStructure"

        // 1. Build amino acid nodes (colored spheres along the chain)
        let aminoAcidParent = SCNNode()
        aminoAcidParent.name = "aminoAcids"
        for acid in data.aminoAcids {
            let node = buildAminoAcidNode(acid: acid)
            aminoAcidParent.addChildNode(node)
        }
        rootNode.addChildNode(aminoAcidParent)

        // 2. Peptide bond connections between consecutive amino acids
        let bondParent = SCNNode()
        bondParent.name = "peptideBonds"
        for i in 0..<(data.aminoAcids.count - 1) {
            let from = data.aminoAcids[i]
            let to = data.aminoAcids[i + 1]
            let bond = createCylinderBetween(
                from: from.position, to: to.position,
                radius: 0.04, material: materials.loopMaterial
            )
            bond.name = "bond_\(i)"
            bondParent.addChildNode(bond)
        }
        rootNode.addChildNode(bondParent)

        // 3. Alpha helix ribbons (architectural spiral ramps)
        for (i, helix) in data.helixSegments.enumerated() {
            let helixNode = buildAlphaHelixRibbon(segment: helix, acids: data.aminoAcids, material: materials.proteinHelixMaterial)
            helixNode.name = "helix_\(i)"
            rootNode.addChildNode(helixNode)
        }

        // 4. Beta sheet platforms
        for (i, sheet) in data.sheetSegments.enumerated() {
            let sheetNode = buildBetaSheetPlatform(segment: sheet, acids: data.aminoAcids, material: materials.proteinSheetMaterial)
            sheetNode.name = "sheet_\(i)"
            rootNode.addChildNode(sheetNode)
        }

        // 5. Loop decorations
        for (i, loop) in data.loops.enumerated() {
            let loopNode = buildLoopDecoration(segment: loop, acids: data.aminoAcids, material: materials.loopMaterial)
            loopNode.name = "loop_\(i)"
            rootNode.addChildNode(loopNode)
        }

        // 6. Base platform
        let platform = buildBasePlatform(material: materials.proteinSheetMaterial)
        rootNode.addChildNode(platform)

        // 7. Hotspot markers for educational stops
        let stops = ProteinEducationalContent.stops
        for stop in stops {
            let marker = buildHotspotMarker(at: stop.position, material: materials.hotspotGlow)
            marker.name = stop.nodeIdentifier
            rootNode.addChildNode(marker)
        }

        return rootNode
    }

    // MARK: - Amino Acid Nodes

    private static func buildAminoAcidNode(acid: AminoAcidData) -> SCNNode {
        let node = SCNNode()
        node.name = "amino_\(acid.id)"

        // Main sphere
        let sphere = SCNSphere(radius: 0.15)
        sphere.segmentCount = 16
        sphere.firstMaterial = MonumentMaterials.aminoAcidMaterial(for: acid.color)
        let sphereNode = SCNNode(geometry: sphere)
        node.addChildNode(sphereNode)

        // Small label plate above
        let textGeo = SCNText(string: acid.threeLetterCode, extrusionDepth: 0.01)
        textGeo.font = UIFont.systemFont(ofSize: 0.1, weight: .medium)
        textGeo.flatness = 0.3
        let textMaterial = SCNMaterial()
        textMaterial.diffuse.contents = UIColor.white
        textMaterial.emission.contents = UIColor(white: 1.0, alpha: 0.5)
        textMaterial.emission.intensity = 0.5
        textGeo.firstMaterial = textMaterial

        let textNode = SCNNode(geometry: textGeo)
        // Center the text
        let (min, max) = textNode.boundingBox
        let textWidth = max.x - min.x
        textNode.position = SCNVector3(-textWidth / 2, 0.22, 0)
        textNode.scale = SCNVector3(0.8, 0.8, 0.8)

        // Billboard constraint so text always faces camera
        let billboard = SCNBillboardConstraint()
        billboard.freeAxes = .all
        textNode.constraints = [billboard]

        node.addChildNode(textNode)
        node.position = acid.position

        return node
    }

    // MARK: - Alpha Helix Ribbon

    private static func buildAlphaHelixRibbon(segment: HelixSegment, acids: [AminoAcidData], material: SCNMaterial) -> SCNNode {
        let ribbonNode = SCNNode()

        guard segment.startIndex < acids.count, segment.endIndex < acids.count else { return ribbonNode }

        // Build a spiral ribbon around the helix axis
        let helixAcids = Array(acids[segment.startIndex...segment.endIndex])
        let ribbonRadius: Float = 0.35
        let steps = helixAcids.count * 4

        for i in 0..<steps {
            let t = Float(i) / Float(steps)
            let acidIndex = min(Int(t * Float(helixAcids.count - 1)), helixAcids.count - 1)
            let nextIndex = min(acidIndex + 1, helixAcids.count - 1)

            // Interpolate position along the backbone
            let blend = t * Float(helixAcids.count - 1) - Float(acidIndex)
            let pos = interpolate(helixAcids[acidIndex].position, helixAcids[nextIndex].position, t: blend)

            // Spiral offset
            let angle = t * Float.pi * 2 * Float(helixAcids.count) / 3.6
            let offsetX = ribbonRadius * cos(angle)
            let offsetZ = ribbonRadius * sin(angle)

            // Small box segment for the ribbon
            let segment = SCNBox(width: 0.12, height: 0.04, length: 0.25, chamferRadius: 0.01)
            segment.firstMaterial = material
            let segNode = SCNNode(geometry: segment)
            segNode.position = SCNVector3(pos.x + offsetX, pos.y, pos.z + offsetZ)
            segNode.eulerAngles.y = angle

            ribbonNode.addChildNode(segNode)
        }

        return ribbonNode
    }

    // MARK: - Beta Sheet Platform

    private static func buildBetaSheetPlatform(segment: SheetSegment, acids: [AminoAcidData], material: SCNMaterial) -> SCNNode {
        let platformNode = SCNNode()

        guard segment.startIndex < acids.count, segment.endIndex < acids.count else { return platformNode }

        let sheetAcids = Array(acids[segment.startIndex...segment.endIndex])

        // Calculate bounds
        var minX: Float = .greatestFiniteMagnitude, maxX: Float = -.greatestFiniteMagnitude
        var avgY: Float = 0
        var avgZ: Float = 0

        for acid in sheetAcids {
            minX = min(minX, acid.position.x)
            maxX = max(maxX, acid.position.x)
            avgY += acid.position.y
            avgZ += acid.position.z
        }
        avgY /= Float(sheetAcids.count)
        avgZ /= Float(sheetAcids.count)

        let width = CGFloat(maxX - minX + 0.6)
        let depth: CGFloat = 1.0

        // Main flat platform
        let platform = SCNBox(width: width, height: 0.08, length: depth, chamferRadius: 0.03)
        platform.firstMaterial = material
        let platNode = SCNNode(geometry: platform)
        platNode.position = SCNVector3((minX + maxX) / 2, avgY - 0.2, avgZ)
        platformNode.addChildNode(platNode)

        // Arrow indicators showing strand direction (like pleated sheet arrows)
        let arrowLength: CGFloat = 0.4
        let arrow = SCNPyramid(width: 0.3, height: 0.06, length: arrowLength)
        arrow.firstMaterial = material
        let arrowNode = SCNNode(geometry: arrow)
        arrowNode.position = SCNVector3(maxX + Float(arrowLength) / 2, avgY - 0.2, avgZ)
        arrowNode.eulerAngles = SCNVector3(0, -Float.pi / 2, 0)
        platformNode.addChildNode(arrowNode)

        // Pleated texture lines
        let stripeCount = max(2, Int(width / 0.3))
        for i in 0..<stripeCount {
            let t = Float(i) / Float(stripeCount - 1)
            let x = minX + t * (maxX - minX)
            let stripe = SCNBox(width: 0.02, height: 0.09, length: depth * 0.9, chamferRadius: 0)
            let stripeMat = SCNMaterial()
            stripeMat.diffuse.contents = UIColor.white.withAlphaComponent(0.3)
            stripe.firstMaterial = stripeMat
            let stripeNode = SCNNode(geometry: stripe)
            stripeNode.position = SCNVector3(x, avgY - 0.16, avgZ)
            platformNode.addChildNode(stripeNode)
        }

        return platformNode
    }

    // MARK: - Loop Decoration

    private static func buildLoopDecoration(segment: LoopSegment, acids: [AminoAcidData], material: SCNMaterial) -> SCNNode {
        let loopNode = SCNNode()

        guard segment.startIndex < acids.count, segment.endIndex < acids.count else { return loopNode }

        // Draw a curved handrail along the loop
        let loopAcids = Array(acids[segment.startIndex...segment.endIndex])

        for i in 0..<(loopAcids.count - 1) {
            let from = loopAcids[i].position
            let to = loopAcids[i + 1].position

            // Handrail slightly offset above the backbone
            let railFrom = SCNVector3(from.x, from.y + 0.2, from.z)
            let railTo = SCNVector3(to.x, to.y + 0.2, to.z)

            let rail = createCylinderBetween(from: railFrom, to: railTo, radius: 0.03, material: material)
            loopNode.addChildNode(rail)

            // Post connecting backbone to handrail
            let post = createCylinderBetween(from: from, to: railFrom, radius: 0.015, material: material)
            loopNode.addChildNode(post)
        }

        return loopNode
    }

    // MARK: - Base Platform

    private static func buildBasePlatform(material: SCNMaterial) -> SCNNode {
        let platform = SCNCylinder(radius: 3.0, height: 0.12)
        platform.radialSegmentCount = 32
        platform.firstMaterial = material
        let node = SCNNode(geometry: platform)
        node.position = SCNVector3(0.5, -0.15, 0.5)
        node.name = "basePlatform"
        return node
    }

    // MARK: - Hotspot Marker

    private static func buildHotspotMarker(at position: SCNVector3, material: SCNMaterial) -> SCNNode {
        let markerNode = SCNNode()

        let sphere = SCNSphere(radius: 0.18)
        sphere.segmentCount = 24
        sphere.firstMaterial = material
        let sphereNode = SCNNode(geometry: sphere)
        markerNode.addChildNode(sphereNode)

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
        markerNode.runAction(SCNAction.repeatForever(SCNAction.sequence([scaleUp, scaleDown])))

        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 4.0))
        ringNode.runAction(rotate)

        return markerNode
    }

    // MARK: - Utilities

    private static func interpolate(_ a: SCNVector3, _ b: SCNVector3, t: Float) -> SCNVector3 {
        SCNVector3(
            a.x + (b.x - a.x) * t,
            a.y + (b.y - a.y) * t,
            a.z + (b.z - a.z) * t
        )
    }

    private static func createCylinderBetween(from: SCNVector3, to: SCNVector3, radius: Float, material: SCNMaterial) -> SCNNode {
        let dx = to.x - from.x
        let dy = to.y - from.y
        let dz = to.z - from.z
        let distance = sqrt(dx * dx + dy * dy + dz * dz)

        let cylinder = SCNCylinder(radius: CGFloat(radius), height: CGFloat(distance))
        cylinder.radialSegmentCount = 12
        cylinder.firstMaterial = material

        let node = SCNNode(geometry: cylinder)
        node.position = SCNVector3(
            (from.x + to.x) / 2,
            (from.y + to.y) / 2,
            (from.z + to.z) / 2
        )

        let direction = SCNVector3(dx, dy, dz)
        let up = SCNVector3(0, 1, 0)
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
            node.rotation = SCNVector4(1, 0, 0, Float.pi)
        }

        return node
    }
}
