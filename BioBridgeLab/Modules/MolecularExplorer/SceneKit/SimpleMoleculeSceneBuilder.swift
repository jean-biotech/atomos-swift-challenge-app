import SceneKit
import SwiftUI

/// Builds 3D scenes for the 5 new molecules using basic SceneKit primitives.
/// Each molecule is a stylized, Monument Valley–inspired representation.
struct SimpleMoleculeSceneBuilder {

    // MARK: - Public Entry Point

    static func build(for molecule: ExplorerState.MoleculeType, materials: MonumentMaterials) -> SCNNode {
        switch molecule {
        case .cellMembrane: return buildCellMembrane(materials: materials)
        case .atp:          return buildATP(materials: materials)
        case .hemoglobin:   return buildHemoglobin(materials: materials)
        case .water:        return buildWater(materials: materials)
        case .glucose:      return buildGlucose(materials: materials)
        default:            return SCNNode() // DNA and Protein use dedicated builders
        }
    }

    // MARK: - Cell Membrane

    private static func buildCellMembrane(materials: MonumentMaterials) -> SCNNode {
        let root = SCNNode()
        root.name = "cellMembrane"

        let headMaterial = makeMatte(UIColor(.monumentPeach))
        let tailMaterial = makeMatte(UIColor(.dnaTeal).withAlphaComponent(0.7))
        let proteinMaterial = makeMatte(UIColor(.monumentLavender))
        let cholesterolMaterial = makeMatte(UIColor(.enzymeOrange))

        // Build two rows of phospholipids (bilayer)
        let columns = 9
        let spacing: Float = 0.7

        for row in 0...1 {
            let yBase: Float = row == 0 ? 4.0 : 2.0
            let tailDirection: Float = row == 0 ? -1 : 1

            for col in 0..<columns {
                let x = Float(col - columns / 2) * spacing

                // Phospholipid head
                let head = SCNSphere(radius: 0.22)
                head.segmentCount = 16
                head.firstMaterial = headMaterial
                let headNode = SCNNode(geometry: head)
                headNode.position = SCNVector3(x, yBase, 0)
                if row == 0 && col == columns / 2 { headNode.name = "hotspot_phospholipid" }
                root.addChildNode(headNode)

                // Two tails
                for t in 0...1 {
                    let tailOffset: Float = t == 0 ? -0.1 : 0.1
                    let tail = SCNCylinder(radius: 0.04, height: 0.7)
                    tail.firstMaterial = tailMaterial
                    let tailNode = SCNNode(geometry: tail)
                    tailNode.position = SCNVector3(x + tailOffset, yBase + tailDirection * 0.55, 0)
                    if row == 0 && col == columns / 2 && t == 0 { tailNode.name = "hotspot_bilayer" }
                    root.addChildNode(tailNode)
                }
            }
        }

        // Integral protein (channel through membrane)
        let channel = SCNCylinder(radius: 0.3, height: 2.4)
        channel.radialSegmentCount = 16
        channel.firstMaterial = proteinMaterial
        let channelNode = SCNNode(geometry: channel)
        channelNode.position = SCNVector3(0, 3.0, 0)
        channelNode.name = "hotspot_integralProtein"
        root.addChildNode(channelNode)

        // Channel hole
        let hole = SCNCylinder(radius: 0.12, height: 2.5)
        hole.firstMaterial = makeMatte(UIColor.black.withAlphaComponent(0.8))
        let holeNode = SCNNode(geometry: hole)
        holeNode.position = SCNVector3(0, 3.0, 0)
        root.addChildNode(holeNode)

        // Cholesterol wedged between lipids
        let cholesterol = SCNBox(width: 0.2, height: 0.5, length: 0.15, chamferRadius: 0.05)
        cholesterol.firstMaterial = cholesterolMaterial
        let cholNode = SCNNode(geometry: cholesterol)
        cholNode.position = SCNVector3(-1.4, 3.0, 0)
        cholNode.name = "hotspot_cholesterol"
        root.addChildNode(cholNode)

        // Glycoprotein (sugar chains on top)
        let glycoBase = SCNSphere(radius: 0.2)
        glycoBase.firstMaterial = proteinMaterial
        let glycoNode = SCNNode(geometry: glycoBase)
        glycoNode.position = SCNVector3(2.1, 4.0, 0)
        glycoNode.name = "hotspot_glycoprotein"
        root.addChildNode(glycoNode)

        for i in 0..<3 {
            let sugar = SCNSphere(radius: 0.08)
            sugar.firstMaterial = makeMatte(UIColor(.successGreen))
            let sugarNode = SCNNode(geometry: sugar)
            sugarNode.position = SCNVector3(2.1 + Float(i) * 0.15 - 0.15, 4.4 + Float(i) * 0.12, 0)
            root.addChildNode(sugarNode)
        }

        // Hotspot markers
        addHotspots(to: root, content: CellMembraneEducationalContent.stops, materials: materials)

        return root
    }

    // MARK: - ATP

    private static func buildATP(materials: MonumentMaterials) -> SCNNode {
        let root = SCNNode()
        root.name = "atp"

        let adenineMaterial = makeMatte(UIColor(.dnaTeal))
        let riboseMaterial = makeMatte(UIColor(.monumentPeach))
        let phosphateMaterial = makeMatte(UIColor(.enzymeOrange))
        let bondMaterial = makeMatte(UIColor(.warningRed))

        // Adenine base — double ring (two fused hexagons)
        let ring1 = SCNTorus(ringRadius: 0.5, pipeRadius: 0.1)
        ring1.firstMaterial = adenineMaterial
        let ring1Node = SCNNode(geometry: ring1)
        ring1Node.position = SCNVector3(0, 0, 0)
        ring1Node.eulerAngles.x = Float.pi / 2
        ring1Node.name = "hotspot_adenine"
        root.addChildNode(ring1Node)

        let ring2 = SCNTorus(ringRadius: 0.35, pipeRadius: 0.08)
        ring2.firstMaterial = adenineMaterial
        let ring2Node = SCNNode(geometry: ring2)
        ring2Node.position = SCNVector3(0.4, 0, 0)
        ring2Node.eulerAngles.x = Float.pi / 2
        root.addChildNode(ring2Node)

        // Ribose sugar — pentagon-ish shape
        let ribose = SCNBox(width: 0.6, height: 0.5, length: 0.4, chamferRadius: 0.15)
        ribose.firstMaterial = riboseMaterial
        let riboseNode = SCNNode(geometry: ribose)
        riboseNode.position = SCNVector3(0, 1.2, 0)
        riboseNode.name = "hotspot_ribose"
        root.addChildNode(riboseNode)

        // Connector: adenine to ribose
        let conn1 = SCNCylinder(radius: 0.04, height: 0.6)
        conn1.firstMaterial = makeMatte(UIColor.white.withAlphaComponent(0.5))
        let conn1Node = SCNNode(geometry: conn1)
        conn1Node.position = SCNVector3(0, 0.6, 0)
        root.addChildNode(conn1Node)

        // Three phosphate groups
        let _ = ["α", "β", "γ"] // phosphate labels (unused)
        for i in 0..<3 {
            let y: Float = 2.4 + Float(i) * 1.2
            let size: CGFloat = CGFloat(0.35 - Float(i) * 0.03)

            let phosphate = SCNSphere(radius: size)
            phosphate.segmentCount = 20
            phosphate.firstMaterial = phosphateMaterial
            let pNode = SCNNode(geometry: phosphate)
            pNode.position = SCNVector3(0, y, 0)
            pNode.name = "hotspot_phosphateGroups"
            root.addChildNode(pNode)

            // Bond between phosphates
            if i > 0 {
                let bond = SCNCylinder(radius: 0.06, height: 0.5)
                bond.firstMaterial = i == 2 ? bondMaterial : makeMatte(UIColor.white.withAlphaComponent(0.4))
                let bondNode = SCNNode(geometry: bond)
                bondNode.position = SCNVector3(0, y - 0.6, 0)
                if i == 2 { bondNode.name = "hotspot_highEnergyBond" }
                root.addChildNode(bondNode)
            }

            // Connector: ribose to first phosphate
            if i == 0 {
                let conn2 = SCNCylinder(radius: 0.04, height: 0.6)
                conn2.firstMaterial = makeMatte(UIColor.white.withAlphaComponent(0.4))
                let conn2Node = SCNNode(geometry: conn2)
                conn2Node.position = SCNVector3(0, 1.8, 0)
                root.addChildNode(conn2Node)
            }
        }

        // "Energy burst" decorative ring around terminal bond
        let energyRing = SCNTorus(ringRadius: 0.6, pipeRadius: 0.03)
        energyRing.firstMaterial = makeMatte(UIColor(.warningRed).withAlphaComponent(0.5))
        let energyNode = SCNNode(geometry: energyRing)
        energyNode.position = SCNVector3(0, 4.2, 0)
        energyNode.name = "hotspot_hydrolysis"
        let pulseUp = SCNAction.scale(to: 1.3, duration: 1.0)
        pulseUp.timingMode = .easeInEaseOut
        let pulseDown = SCNAction.scale(to: 1.0, duration: 1.0)
        pulseDown.timingMode = .easeInEaseOut
        energyNode.runAction(SCNAction.repeatForever(SCNAction.sequence([pulseUp, pulseDown])))
        root.addChildNode(energyNode)

        // Hotspot markers
        addHotspots(to: root, content: ATPEducationalContent.stops, materials: materials)

        return root
    }

    // MARK: - Hemoglobin

    private static func buildHemoglobin(materials: MonumentMaterials) -> SCNNode {
        let root = SCNNode()
        root.name = "hemoglobin"

        let alphaMaterial = makeMatte(UIColor(.warningRed))
        let betaMaterial = makeMatte(UIColor(.monumentLavender))
        let hemeMaterial = makeMatte(UIColor(.enzymeOrange))
        let ironMaterial = makeEmissive(UIColor(.proteinGold))

        // Four subunits (2 alpha, 2 beta) in a tetrahedral arrangement
        let subunitPositions: [(SCNVector3, SCNMaterial, String)] = [
            (SCNVector3(-0.8, 0.8, -0.5), alphaMaterial, "alpha1"),
            (SCNVector3(0.8, 0.8, 0.5), alphaMaterial, "alpha2"),
            (SCNVector3(-0.8, 0.8, 0.5), betaMaterial, "beta1"),
            (SCNVector3(0.8, 0.8, -0.5), betaMaterial, "beta2"),
        ]

        for (pos, mat, _) in subunitPositions {
            // Subunit = rounded blob
            let subunit = SCNSphere(radius: 0.9)
            subunit.segmentCount = 24
            subunit.firstMaterial = mat
            let subNode = SCNNode(geometry: subunit)
            subNode.position = pos
            subNode.name = "hotspot_alphaBeta"
            root.addChildNode(subNode)

            // Heme group inside each subunit (flat disc)
            let heme = SCNCylinder(radius: 0.35, height: 0.06)
            heme.radialSegmentCount = 20
            heme.firstMaterial = hemeMaterial
            let hemeNode = SCNNode(geometry: heme)
            hemeNode.position = SCNVector3(pos.x, pos.y + 0.3, pos.z)
            hemeNode.name = "hotspot_heme"
            root.addChildNode(hemeNode)

            // Iron atom at center of heme
            let iron = SCNSphere(radius: 0.08)
            iron.segmentCount = 12
            iron.firstMaterial = ironMaterial
            let ironNode = SCNNode(geometry: iron)
            ironNode.position = SCNVector3(pos.x, pos.y + 0.35, pos.z)
            ironNode.name = "hotspot_iron"
            root.addChildNode(ironNode)
        }

        // Shift everything up for better camera framing
        for child in root.childNodes {
            child.position.y += 2.0
        }

        // Decorative base platform
        let platform = SCNCylinder(radius: 2.0, height: 0.1)
        platform.firstMaterial = makeMatte(UIColor(.dnaTeal).withAlphaComponent(0.3))
        let platNode = SCNNode(geometry: platform)
        platNode.position = SCNVector3(0, 1.0, 0)
        platNode.name = "hotspot_quaternary"
        root.addChildNode(platNode)

        // Oxygen molecules near top (small blue spheres)
        for i in 0..<4 {
            let angle = Float(i) * Float.pi / 2
            let o2 = SCNSphere(radius: 0.1)
            o2.firstMaterial = makeMatte(UIColor(.monumentSky))
            let o2Node = SCNNode(geometry: o2)
            o2Node.name = "hotspot_cooperativity"
            o2Node.position = SCNVector3(
                cos(angle) * 1.5,
                4.5 + Float(i) * 0.3,
                sin(angle) * 1.5
            )
            // Float animation
            let floatUp = SCNAction.moveBy(x: 0, y: 0.2, z: 0, duration: 1.5)
            floatUp.timingMode = .easeInEaseOut
            let floatDown = SCNAction.moveBy(x: 0, y: -0.2, z: 0, duration: 1.5)
            floatDown.timingMode = .easeInEaseOut
            o2Node.runAction(SCNAction.repeatForever(SCNAction.sequence([floatUp, floatDown])))
            root.addChildNode(o2Node)
        }

        // Hotspot markers
        addHotspots(to: root, content: HemoglobinEducationalContent.stops, materials: materials)

        return root
    }

    // MARK: - Water

    private static func buildWater(materials: MonumentMaterials) -> SCNNode {
        let root = SCNNode()
        root.name = "waterMolecule"

        let oxygenMaterial = makeMatte(UIColor(.warningRed))
        let hydrogenMaterial = makeMatte(UIColor.white)
        let bondMaterial = makeMatte(UIColor(.monumentSky).withAlphaComponent(0.6))
        let hBondMaterial = makeMatte(UIColor(.dnaTeal).withAlphaComponent(0.3))

        // Build a central water molecule (large)
        let centralO = SCNSphere(radius: 0.6)
        centralO.segmentCount = 24
        centralO.firstMaterial = oxygenMaterial
        let oNode = SCNNode(geometry: centralO)
        oNode.position = SCNVector3(0, 1.5, 0)
        oNode.name = "hotspot_oxygen"
        root.addChildNode(oNode)

        // 104.5° bond angle - two hydrogens
        let bondAngle: Float = 104.5 * Float.pi / 180
        let bondLength: Float = 1.2

        let h1Pos = SCNVector3(
            -bondLength * sin(bondAngle / 2),
            1.5 + bondLength * cos(bondAngle / 2),
            0
        )
        let h2Pos = SCNVector3(
            bondLength * sin(bondAngle / 2),
            1.5 + bondLength * cos(bondAngle / 2),
            0
        )

        for (_, pos) in [h1Pos, h2Pos].enumerated() {
            let h = SCNSphere(radius: 0.35)
            h.segmentCount = 20
            h.firstMaterial = hydrogenMaterial
            let hNode = SCNNode(geometry: h)
            hNode.position = pos
            hNode.name = "hotspot_hydrogen"
            root.addChildNode(hNode)

            // Bond cylinder
            let bond = createCylinderBetween(
                from: SCNVector3(0, 1.5, 0),
                to: pos,
                radius: 0.08,
                material: bondMaterial
            )
            bond.name = "hotspot_covalentBond"
            root.addChildNode(bond)
        }

        // Surrounding water molecules (smaller, showing hydrogen bonding network)
        let neighborPositions: [SCNVector3] = [
            SCNVector3(-2.0, 0.5, 0),
            SCNVector3(2.0, 0.5, 0),
            SCNVector3(0, 3.5, 1.5),
            SCNVector3(0, -0.5, -1.5),
        ]

        for nPos in neighborPositions {
            let smallO = SCNSphere(radius: 0.3)
            smallO.segmentCount = 16
            smallO.firstMaterial = oxygenMaterial
            let sONode = SCNNode(geometry: smallO)
            sONode.position = nPos
            root.addChildNode(sONode)

            // Small hydrogens
            let sH1 = SCNSphere(radius: 0.18)
            sH1.firstMaterial = hydrogenMaterial
            let sH1Node = SCNNode(geometry: sH1)
            sH1Node.position = SCNVector3(nPos.x - 0.3, nPos.y + 0.4, nPos.z)
            root.addChildNode(sH1Node)

            let sH2 = SCNSphere(radius: 0.18)
            sH2.firstMaterial = hydrogenMaterial
            let sH2Node = SCNNode(geometry: sH2)
            sH2Node.position = SCNVector3(nPos.x + 0.3, nPos.y + 0.4, nPos.z)
            root.addChildNode(sH2Node)

            // Dashed hydrogen bond to central molecule
            let hBond = createDashedLine(
                from: nPos,
                to: SCNVector3(0, 1.5, 0),
                material: hBondMaterial
            )
            hBond.name = "hotspot_hydrogenBond"
            root.addChildNode(hBond)
        }

        // Angle indicator arc
        let arc = SCNTorus(ringRadius: 0.5, pipeRadius: 0.02)
        arc.firstMaterial = makeMatte(UIColor(.successGreen).withAlphaComponent(0.5))
        let arcNode = SCNNode(geometry: arc)
        arcNode.position = SCNVector3(0, 2.0, 0)
        arcNode.eulerAngles.x = Float.pi / 4
        arcNode.name = "hotspot_bondAngle"
        root.addChildNode(arcNode)

        // Hotspot markers
        addHotspots(to: root, content: WaterMoleculeEducationalContent.stops, materials: materials)

        return root
    }

    // MARK: - Glucose

    private static func buildGlucose(materials: MonumentMaterials) -> SCNNode {
        let root = SCNNode()
        root.name = "glucose"

        let carbonMaterial = makeMatte(UIColor(.dnaTeal))
        let oxygenMaterial = makeMatte(UIColor(.warningRed))
        let hydroxylMaterial = makeMatte(UIColor(.successGreen))
        let bondMaterial = makeMatte(UIColor.white.withAlphaComponent(0.4))

        // Pyranose ring — 6 atoms in a ring (5C + 1O)
        let ringRadius: Float = 1.2
        let ringY: Float = 2.0

        var ringPositions: [SCNVector3] = []
        for i in 0..<6 {
            let angle = Float(i) * (2 * Float.pi / 6) - Float.pi / 6
            let x = ringRadius * cos(angle)
            let z = ringRadius * sin(angle)
            let pos = SCNVector3(x, ringY, z)
            ringPositions.append(pos)

            let isOxygen = (i == 5) // Last atom in ring is oxygen
            let atom = SCNSphere(radius: isOxygen ? 0.22 : 0.25)
            atom.segmentCount = 16
            atom.firstMaterial = isOxygen ? oxygenMaterial : carbonMaterial
            let atomNode = SCNNode(geometry: atom)
            atomNode.position = pos
            if i == 0 { atomNode.name = "hotspot_pyranoseRing" }
            else if i == 2 { atomNode.name = "hotspot_carbonBackbone" }
            else if i == 5 { atomNode.name = "hotspot_alphaBeta" }
            root.addChildNode(atomNode)

            // Hydroxyl groups (on carbons, alternating above/below ring)
            if !isOxygen && i < 5 {
                let hydroxylY = (i % 2 == 0) ? ringY + 0.5 : ringY - 0.5
                let hydroxyl = SCNSphere(radius: 0.15)
                hydroxyl.firstMaterial = hydroxylMaterial
                let hNode = SCNNode(geometry: hydroxyl)
                hNode.position = SCNVector3(x * 1.3, hydroxylY, z * 1.3)
                if i == 1 { hNode.name = "hotspot_hydroxyl" }
                root.addChildNode(hNode)

                // Bond to hydroxyl
                let hBond = createCylinderBetween(from: pos, to: hNode.position, radius: 0.03, material: bondMaterial)
                root.addChildNode(hBond)
            }
        }

        // Ring bonds
        for i in 0..<6 {
            let from = ringPositions[i]
            let to = ringPositions[(i + 1) % 6]
            let bond = createCylinderBetween(from: from, to: to, radius: 0.06, material: bondMaterial)
            root.addChildNode(bond)
        }

        // CH2OH tail hanging off C5
        let tailPos = SCNVector3(ringPositions[4].x * 1.5, ringY + 0.8, ringPositions[4].z * 1.5)
        let tailCarbon = SCNSphere(radius: 0.2)
        tailCarbon.firstMaterial = carbonMaterial
        let tailNode = SCNNode(geometry: tailCarbon)
        tailNode.position = tailPos
        tailNode.name = "hotspot_glycosidicBond"
        root.addChildNode(tailNode)

        let tailBond = createCylinderBetween(from: ringPositions[4], to: tailPos, radius: 0.04, material: bondMaterial)
        root.addChildNode(tailBond)

        // Decorative base
        let platform = SCNCylinder(radius: 2.0, height: 0.08)
        platform.firstMaterial = makeMatte(UIColor(.successGreen).withAlphaComponent(0.2))
        let platNode = SCNNode(geometry: platform)
        platNode.position = SCNVector3(0, 0, 0)
        root.addChildNode(platNode)

        // Hotspot markers
        addHotspots(to: root, content: GlucoseEducationalContent.stops, materials: materials)

        return root
    }

    // MARK: - Shared Helpers

    private static func addHotspots(to root: SCNNode, content: [EducationalStop], materials: MonumentMaterials) {
        for stop in content {
            let marker = buildHotspotMarker(at: stop.position, material: materials.hotspotGlow)
            marker.name = stop.nodeIdentifier
            root.addChildNode(marker)
        }
    }

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

        let scaleUp = SCNAction.scale(to: 1.2, duration: 1.0)
        scaleUp.timingMode = .easeInEaseOut
        let scaleDown = SCNAction.scale(to: 1.0, duration: 1.0)
        scaleDown.timingMode = .easeInEaseOut
        markerNode.runAction(SCNAction.repeatForever(SCNAction.sequence([scaleUp, scaleDown])))

        let rotate = SCNAction.repeatForever(
            SCNAction.rotateBy(x: 0, y: CGFloat.pi * 2, z: 0, duration: 4.0)
        )
        ringNode.runAction(rotate)

        return markerNode
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

    private static func createDashedLine(from: SCNVector3, to: SCNVector3, material: SCNMaterial) -> SCNNode {
        let container = SCNNode()
        let dx = to.x - from.x
        let dy = to.y - from.y
        let dz = to.z - from.z
        let totalDist = sqrt(dx * dx + dy * dy + dz * dz)

        let segments = 5
        let _: Float = totalDist / Float(segments * 2) // dashLength unused

        for i in 0..<segments {
            let t1 = Float(i * 2) / Float(segments * 2)
            let t2 = Float(i * 2 + 1) / Float(segments * 2)

            let p1 = SCNVector3(from.x + dx * t1, from.y + dy * t1, from.z + dz * t1)
            let p2 = SCNVector3(from.x + dx * t2, from.y + dy * t2, from.z + dz * t2)

            let dash = createCylinderBetween(from: p1, to: p2, radius: 0.02, material: material)
            container.addChildNode(dash)
        }

        return container
    }

    // MARK: - Material Helpers

    private static func makeMatte(_ color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = color
        material.roughness.contents = NSNumber(value: 0.7)
        material.metalness.contents = NSNumber(value: 0.0)
        material.isDoubleSided = true
        return material
    }

    private static func makeEmissive(_ color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = color
        material.emission.contents = color
        material.emission.intensity = 0.6
        material.roughness.contents = NSNumber(value: 0.3)
        material.metalness.contents = NSNumber(value: 0.0)
        material.isDoubleSided = true
        return material
    }
}
