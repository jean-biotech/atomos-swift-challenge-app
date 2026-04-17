import SceneKit

struct ATPEducationalContent {
    static let stops: [EducationalStop] = [
        EducationalStop(
            id: 0,
            title: "Adenine Base",
            description: "The same molecular letter found in DNA, repurposed for energy.",
            detail: "Adenine is a purine \u{2014} a type of molecule made of two fused rings containing nitrogen. It's the same \"A\" base found in DNA and RNA. Evolution cleverly reused this molecular building block for a completely different purpose: energy storage. This shows how nature is economical, recycling successful designs across different systems.",
            icon: "hexagon.fill",
            nodeIdentifier: "hotspot_adenine",
            position: SCNVector3(0, 0, 0)
        ),
        EducationalStop(
            id: 1,
            title: "Ribose Sugar",
            description: "A five-carbon sugar that connects the base to the energy-storing tail.",
            detail: "Ribose is a pentose (five-carbon) sugar that acts as the central scaffold of ATP, linking the adenine base to the phosphate chain. Unlike the deoxyribose in DNA (which is missing one oxygen), ribose has an extra hydroxyl (-OH) group. This is why ATP is technically a ribonucleotide \u{2014} a close relative of the building blocks used to make RNA.",
            icon: "pentagon.fill",
            nodeIdentifier: "hotspot_ribose",
            position: SCNVector3(0, 1.2, 0)
        ),
        EducationalStop(
            id: 2,
            title: "Three Phosphate Groups",
            description: "The energy-storing tail \u{2014} packed with tension like a compressed spring.",
            detail: "ATP carries three phosphate groups labeled alpha (\u{03B1}), beta (\u{03B2}), and gamma (\u{03B3}). Each phosphate is negatively charged, so packing three of them close together creates strong electrical repulsion (like pushing the same poles of magnets together). This built-in tension is exactly what makes ATP such an effective energy carrier \u{2014} it's spring-loaded and ready to release energy.",
            icon: "circle.grid.3x3.fill",
            nodeIdentifier: "hotspot_phosphateGroups",
            position: SCNVector3(0, 2.4, 0)
        ),
        EducationalStop(
            id: 3,
            title: "High-Energy Phosphate Bonds",
            description: "Breaking these bonds powers nearly everything your cells do.",
            detail: "The bonds between the second and third phosphate groups store usable energy. When water breaks this bond (a reaction called hydrolysis, meaning \"water splitting\"), it releases about 7.3 kilocalories per mole of energy \u{2014} enough to power muscle contraction, nerve impulses, protein building, and thousands of other cellular processes.",
            icon: "bolt.fill",
            nodeIdentifier: "hotspot_highEnergyBond",
            position: SCNVector3(0, 3.6, 0)
        ),
        EducationalStop(
            id: 4,
            title: "ATP \u{2192} ADP + Pi",
            description: "The universal energy transaction of life.",
            detail: "When the terminal (gamma) phosphate is snipped off by an enzyme, ATP becomes ADP (adenosine diphosphate) plus a free phosphate (Pi). The released energy is then coupled to drive cellular reactions that wouldn't happen on their own. Think of ATP as a rechargeable battery: it's charged up in your mitochondria and discharged wherever energy is needed.",
            icon: "arrow.right.circle",
            nodeIdentifier: "hotspot_hydrolysis",
            position: SCNVector3(0, 4.8, 0)
        ),
        EducationalStop(
            id: 5,
            title: "ATP Synthase",
            description: "A tiny molecular motor that manufactures ATP.",
            detail: "ATP synthase is a remarkable rotary enzyme embedded in the mitochondrial membrane. As hydrogen ions (protons) flow through it like water through a turbine, it physically spins \u{2014} one of the smallest known motors in nature. Each rotation forces ADP and a phosphate back together, recharging the ATP battery. Your body recycles roughly its own weight in ATP every single day through this process.",
            icon: "gearshape.2.fill",
            nodeIdentifier: "hotspot_atpSynthase",
            position: SCNVector3(0, 6.0, 0)
        ),
    ]
}
