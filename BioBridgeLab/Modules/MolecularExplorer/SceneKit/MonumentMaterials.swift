import SceneKit
import SwiftUI

struct MonumentMaterials {
    let backboneTeal: SCNMaterial
    let backbonePink: SCNMaterial
    let basePairGold: SCNMaterial
    let basePairTeal: SCNMaterial
    let hotspotGlow: SCNMaterial
    let pathMaterial: SCNMaterial
    let characterBody: SCNMaterial
    let characterHead: SCNMaterial
    let proteinHelixMaterial: SCNMaterial
    let proteinSheetMaterial: SCNMaterial
    let loopMaterial: SCNMaterial

    static func create() -> MonumentMaterials {
        MonumentMaterials(
            backboneTeal: makeMatte(color: UIColor(.dnaTeal)),
            backbonePink: makeMatte(color: UIColor(.dnaPink)),
            basePairGold: makeMatte(color: UIColor(.baseA), alpha: 0.9),
            basePairTeal: makeMatte(color: UIColor(.baseG), alpha: 0.9),
            hotspotGlow: makeEmissive(color: UIColor(.hotspotGlow)),
            pathMaterial: makeTranslucent(color: UIColor(.white), alpha: 0.15),
            characterBody: makeCharacter(color: .white),
            characterHead: makeCharacter(color: .white),
            proteinHelixMaterial: makeMatte(color: UIColor(.monumentLavender)),
            proteinSheetMaterial: makeMatte(color: UIColor(.monumentPeach)),
            loopMaterial: makeMatte(color: UIColor(.monumentSky))
        )
    }

    static func aminoAcidMaterial(for color: Color) -> SCNMaterial {
        makeMatte(color: UIColor(color))
    }

    // MARK: - Material Factories

    private static func makeMatte(color: UIColor, alpha: CGFloat = 1.0) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = color.withAlphaComponent(alpha)
        material.roughness.contents = NSNumber(value: 0.7)
        material.metalness.contents = NSNumber(value: 0.0)
        material.isDoubleSided = true
        return material
    }

    private static func makeEmissive(color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = color
        material.emission.contents = color
        material.emission.intensity = 0.8
        material.roughness.contents = NSNumber(value: 0.3)
        material.metalness.contents = NSNumber(value: 0.0)
        material.isDoubleSided = true
        return material
    }

    private static func makeTranslucent(color: UIColor, alpha: CGFloat) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = color.withAlphaComponent(alpha)
        material.roughness.contents = NSNumber(value: 0.5)
        material.metalness.contents = NSNumber(value: 0.0)
        material.transparency = alpha
        material.isDoubleSided = true
        return material
    }

    private static func makeCharacter(color: UIColor) -> SCNMaterial {
        let material = SCNMaterial()
        material.lightingModel = .physicallyBased
        material.diffuse.contents = color
        material.emission.contents = UIColor(white: 1.0, alpha: 0.3)
        material.emission.intensity = 0.3
        material.roughness.contents = NSNumber(value: 0.4)
        material.metalness.contents = NSNumber(value: 0.0)
        return material
    }
}
