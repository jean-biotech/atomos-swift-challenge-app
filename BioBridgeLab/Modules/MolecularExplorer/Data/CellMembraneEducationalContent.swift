import SceneKit

struct CellMembraneEducationalContent {
    static let stops: [EducationalStop] = [
        EducationalStop(
            id: 0,
            title: "Phospholipid Molecule",
            description: "The fundamental building block of cell membranes.",
            detail: "Each phospholipid has a hydrophilic (water-loving) phosphate head and two hydrophobic (water-fearing) fatty acid tails. This dual nature, called amphipathic, is what allows phospholipids to spontaneously form membranes in watery environments.",
            icon: "drop.circle",
            nodeIdentifier: "hotspot_phospholipid",
            position: SCNVector3(0, 0, 0)
        ),
        EducationalStop(
            id: 1,
            title: "Lipid Bilayer",
            description: "Two layers of phospholipids arranged tail-to-tail.",
            detail: "The hydrophobic tails face inward, away from water, while the hydrophilic heads face outward toward the aqueous environment on both sides. This arrangement forms spontaneously because it is the most thermodynamically stable configuration, creating a barrier just 7\u{2013}8 nanometers thick.",
            icon: "rectangle.split.2x1",
            nodeIdentifier: "hotspot_bilayer",
            position: SCNVector3(0, 1.6, 0)
        ),
        EducationalStop(
            id: 2,
            title: "Integral Proteins",
            description: "Proteins that span the entire membrane.",
            detail: "Channel and carrier proteins are embedded through the lipid bilayer, providing passageways for ions and polar molecules that cannot cross the hydrophobic interior on their own. Ion channels can open and close like gates, allowing cells to control the flow of sodium, potassium, and calcium ions critical for nerve signaling.",
            icon: "arrow.up.and.down.circle",
            nodeIdentifier: "hotspot_integralProtein",
            position: SCNVector3(0, 3.2, 0)
        ),
        EducationalStop(
            id: 3,
            title: "Cholesterol",
            description: "A lipid that fine-tunes membrane fluidity.",
            detail: "Cholesterol molecules wedge between phospholipids, preventing the fatty acid tails from packing too closely at low temperatures or moving too freely at high temperatures. This buffering effect keeps the membrane at the right consistency\u{2014}fluid enough for proteins to move, yet firm enough to maintain structure.",
            icon: "thermometer.medium",
            nodeIdentifier: "hotspot_cholesterol",
            position: SCNVector3(0, 4.8, 0)
        ),
        EducationalStop(
            id: 4,
            title: "Glycoproteins",
            description: "Sugar-coated proteins used for cell recognition.",
            detail: "Short carbohydrate chains attached to membrane proteins act like molecular ID tags. The immune system uses glycoproteins to distinguish your own cells from foreign invaders, which is why matching blood types and tissue types matters for transfusions and organ transplants.",
            icon: "person.crop.circle.badge.checkmark",
            nodeIdentifier: "hotspot_glycoprotein",
            position: SCNVector3(0, 6.4, 0)
        ),
        EducationalStop(
            id: 5,
            title: "Selective Permeability",
            description: "The membrane chooses what enters and exits the cell.",
            detail: "Small nonpolar molecules like oxygen and carbon dioxide slip through freely, but charged ions and large molecules need protein channels or active transport. This selectivity allows cells to maintain internal conditions different from their surroundings\u{2014}a concept called homeostasis that is essential for life.",
            icon: "shield.checkered",
            nodeIdentifier: "hotspot_selectivePermeability",
            position: SCNVector3(0, 8.0, 0)
        ),
    ]
}
