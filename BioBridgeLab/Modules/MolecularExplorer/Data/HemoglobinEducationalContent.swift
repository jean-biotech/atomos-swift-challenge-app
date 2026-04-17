import SceneKit

struct HemoglobinEducationalContent {
    static let stops: [EducationalStop] = [
        EducationalStop(
            id: 0,
            title: "Quaternary Structure",
            description: "Four separate protein chains assembled into one team.",
            detail: "Hemoglobin is a classic example of quaternary structure \u{2014} meaning multiple protein chains (called subunits) join together to form one functional unit. This multi-subunit design allows the chains to \"talk\" to each other: when one picks up oxygen, it nudges the others to do the same. A single chain couldn't pull off this trick.",
            icon: "square.grid.2x2.fill",
            nodeIdentifier: "hotspot_quaternary",
            position: SCNVector3(0, 0, 0)
        ),
        EducationalStop(
            id: 1,
            title: "Alpha and Beta Subunits",
            description: "Two types of chains, two copies each \u{2014} a balanced team.",
            detail: "Adult hemoglobin (HbA) contains two alpha (\u{03B1}) subunits (141 amino acids each) and two beta (\u{03B2}) subunits (146 amino acids each). Despite having different amino acid sequences, both types fold into remarkably similar 3D shapes called the \"globin fold\" \u{2014} a design so successful that evolution has used it in oxygen-binding proteins for over a billion years.",
            icon: "person.2.fill",
            nodeIdentifier: "hotspot_alphaBeta",
            position: SCNVector3(0, 1.6, 0)
        ),
        EducationalStop(
            id: 2,
            title: "Heme Group",
            description: "The flat, ring-shaped molecule that gives blood its red color.",
            detail: "Each subunit contains one heme group \u{2014} a porphyrin ring (four smaller rings connected in a circle) with an iron atom at its center. Heme absorbs certain wavelengths of light, which is why oxygen-rich blood appears bright red and oxygen-poor blood looks darker. The heme group is the business end of hemoglobin, responsible for actually grabbing onto oxygen molecules.",
            icon: "circle.circle",
            nodeIdentifier: "hotspot_heme",
            position: SCNVector3(0, 3.2, 0)
        ),
        EducationalStop(
            id: 3,
            title: "Iron Atom (Fe\u{00B2}\u{207A})",
            description: "A single atom of iron that binds oxygen \u{2014} the star of the show.",
            detail: "At the center of each heme sits one iron ion (Fe\u{00B2}\u{207A}). This iron atom forms a reversible bond with oxygen (O\u{2082}), holding it just tightly enough to pick it up in the lungs and release it in tissues that need it. If the iron gets oxidized (loses an electron, becoming Fe\u{00B3}\u{207A}), hemoglobin can no longer carry oxygen \u{2014} a condition called methemoglobinemia.",
            icon: "atom",
            nodeIdentifier: "hotspot_iron",
            position: SCNVector3(0, 4.8, 0)
        ),
        EducationalStop(
            id: 4,
            title: "Cooperative Oxygen Binding",
            description: "Picking up the first oxygen makes grabbing the rest much easier.",
            detail: "When the first O\u{2082} molecule binds, the subunit shifts shape slightly (a conformational change), which increases the oxygen affinity of the remaining subunits. This domino effect is called cooperativity. It gives hemoglobin an S-shaped (sigmoidal) binding curve, meaning it efficiently loads up with oxygen in the lungs and efficiently dumps it where your muscles and organs need it most.",
            icon: "chart.line.uptrend.xyaxis",
            nodeIdentifier: "hotspot_cooperativity",
            position: SCNVector3(0, 6.4, 0)
        ),
        EducationalStop(
            id: 5,
            title: "Sickle Cell Mutation",
            description: "One tiny DNA change, one amino acid swap, one big consequence.",
            detail: "A single letter change in the beta-globin gene swaps glutamic acid (a charged, water-loving amino acid) for valine (an oily, water-repelling one) at position 6. This makes hemoglobin molecules stick together into rigid fibers when oxygen is low, bending red blood cells into a sickle shape. The good news: CRISPR gene editing is now being used to treat sickle cell disease by reactivating a backup form of hemoglobin.",
            icon: "exclamationmark.triangle.fill",
            nodeIdentifier: "hotspot_sickleMutation",
            position: SCNVector3(0, 8.0, 0)
        ),
    ]
}
