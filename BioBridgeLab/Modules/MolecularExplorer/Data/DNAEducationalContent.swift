import SceneKit

struct DNAEducationalContent {
    static let stops: [EducationalStop] = [
        EducationalStop(
            id: 0,
            title: "The 3\u{2032} End",
            description: "Where new DNA building blocks are added during copying.",
            detail: "The 3\u{2032} (\"three prime\") end has a free hydroxyl group (-OH) on the third carbon of the sugar. Think of it as the \"growing tip\" \u{2014} when your cells copy DNA, the enzyme DNA polymerase adds new nucleotides (DNA letters) here, extending the strand one base at a time.",
            icon: "arrow.down.circle",
            nodeIdentifier: "hotspot_3prime",
            position: SCNVector3(1.5, 0, 0)
        ),
        EducationalStop(
            id: 1,
            title: "Sugar-Phosphate Backbone",
            description: "The structural railing that holds DNA together.",
            detail: "Each strand is held together by alternating sugar and phosphate groups, forming a sturdy \"backbone.\" This backbone carries a negative electrical charge, which makes the outside of DNA attract water (hydrophilic) while keeping the information-carrying bases safely tucked inside.",
            icon: "link",
            nodeIdentifier: "hotspot_backbone",
            position: SCNVector3(1.5, 1.7, 0)
        ),
        EducationalStop(
            id: 2,
            title: "A\u{2013}T Base Pair",
            description: "Adenine always pairs with Thymine \u{2014} no exceptions.",
            detail: "A and T are connected by 2 hydrogen bonds (weak attractions between atoms). This makes A-T pairs slightly weaker than G-C pairs. Regions of DNA rich in A-T pairs denature (split apart into single strands) more easily when heated, which scientists exploit in techniques like PCR.",
            icon: "equal.circle",
            nodeIdentifier: "hotspot_AT",
            position: SCNVector3(-1.5, 3.0, 0)
        ),
        EducationalStop(
            id: 3,
            title: "G\u{2013}C Base Pair",
            description: "Guanine always pairs with Cytosine \u{2014} the stronger pair.",
            detail: "G and C are connected by 3 hydrogen bonds, making this the stronger base pair. GC-rich regions of DNA are more thermally stable and harder to pull apart. This base pairing rule (A with T, G with C) is what allows cells to make perfect copies of DNA every time they divide.",
            icon: "equal.circle.fill",
            nodeIdentifier: "hotspot_GC",
            position: SCNVector3(1.5, 4.4, 0)
        ),
        EducationalStop(
            id: 4,
            title: "Minor Groove",
            description: "The narrower groove \u{2014} a landing spot for small molecules.",
            detail: "The minor groove is the narrower of the two channels that spiral along the DNA surface. Certain proteins and drug molecules bind here to control which genes are turned on or off. It reveals less of the base pair edges compared to the major groove, making it harder for proteins to \"read\" the sequence from here.",
            icon: "arrow.left.and.right.circle",
            nodeIdentifier: "hotspot_minorGroove",
            position: SCNVector3(0, 5.8, 1.5)
        ),
        EducationalStop(
            id: 5,
            title: "Major Groove",
            description: "The wider groove where cells read the genetic code.",
            detail: "The major groove is wider and exposes more of each base pair's edges. This is where transcription factors (proteins that control gene activity) \"read\" the DNA sequence without having to unwind the helix. It's like reading a book through a window \u{2014} the major groove provides a bigger window.",
            icon: "arrow.left.and.right.circle.fill",
            nodeIdentifier: "hotspot_majorGroove",
            position: SCNVector3(0, 7.2, -1.5)
        ),
        EducationalStop(
            id: 6,
            title: "One Complete Turn",
            description: "Every 10 base pairs, the helix completes a full twist.",
            detail: "The most common form of DNA (called B-form) makes one full helical turn every 10 base pairs, spanning 3.4 nanometers \u{2014} about 10,000 times thinner than a human hair. This consistent twist is one of nature's most elegant designs and was first revealed by Rosalind Franklin's X-ray photographs in 1952.",
            icon: "arrow.triangle.2.circlepath",
            nodeIdentifier: "hotspot_fullTurn",
            position: SCNVector3(-1.5, 8.5, 0)
        ),
        EducationalStop(
            id: 7,
            title: "The 5\u{2032} End",
            description: "The starting end of the DNA strand.",
            detail: "The 5\u{2032} (\"five prime\") end has a free phosphate group on the fifth carbon of the sugar. DNA is always read from 5\u{2032} to 3\u{2032}, like reading a book left to right. The two strands run in opposite directions (antiparallel) \u{2014} one goes up while the other goes down \u{2014} which is critical for DNA replication.",
            icon: "arrow.up.circle",
            nodeIdentifier: "hotspot_5prime",
            position: SCNVector3(1.5, 10.0, 0)
        ),
    ]
}
