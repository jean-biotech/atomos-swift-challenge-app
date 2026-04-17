import SceneKit

struct ProteinEducationalContent {
    static let stops: [EducationalStop] = [
        EducationalStop(
            id: 0,
            title: "Amino Acid",
            description: "The 20 building blocks that make up every protein in your body.",
            detail: "Each amino acid has three parts: an amino group (-NH\u{2082}), a carboxyl group (-COOH), and a unique side chain (called the R group) that gives each amino acid its special personality \u{2014} some are oily, some are charged, and some are tiny. Your DNA code specifies which of the 20 amino acids to string together.",
            icon: "circle.fill",
            nodeIdentifier: "hotspot_aminoAcid",
            position: SCNVector3(1.2, 0, 0)
        ),
        EducationalStop(
            id: 1,
            title: "Peptide Bond",
            description: "The chemical link that chains amino acids together.",
            detail: "A peptide bond forms when two amino acids join together, releasing a water molecule in the process (a reaction called dehydration synthesis). This strong covalent bond links the carboxyl group of one amino acid to the amino group of the next, creating a chain that can be hundreds or thousands of amino acids long.",
            icon: "link",
            nodeIdentifier: "hotspot_peptideBond",
            position: SCNVector3(0.6, 1.1, 0.8)
        ),
        EducationalStop(
            id: 2,
            title: "Alpha Helix",
            description: "A coiled-spring shape found in many proteins.",
            detail: "The alpha helix is one of the most common protein shapes. It forms when the backbone twists into a right-handed spiral, stabilized by hydrogen bonds between every 4th amino acid. With 3.6 amino acids per turn, it resembles a coiled spring or spiral staircase. Alpha helices are found in everything from hair (keratin) to muscle fibers.",
            icon: "tornado",
            nodeIdentifier: "hotspot_alphaHelix",
            position: SCNVector3(0, 2.2, 0)
        ),
        EducationalStop(
            id: 3,
            title: "Loop Region",
            description: "Flexible connectors that often form the business end of proteins.",
            detail: "Loops connect the more rigid helices and sheets, acting like hinges between structural elements. Because they're flexible and often sit on the protein's surface, loops frequently form the active sites where proteins do their work \u{2014} binding other molecules, catalyzing reactions, or sending signals.",
            icon: "arrow.triangle.turn.up.right.diamond",
            nodeIdentifier: "hotspot_loop",
            position: SCNVector3(0.5, 4.2, 0.5)
        ),
        EducationalStop(
            id: 4,
            title: "Beta Sheet",
            description: "Flat, ribbon-like structures that provide strength.",
            detail: "Beta sheets form when protein strands lie side-by-side like planks in a raft, connected by hydrogen bonds between their backbones. Strands can run in the same direction (parallel) or opposite directions (antiparallel). Beta sheets create strong, rigid platforms \u{2014} silk gets its incredible strength from stacked beta sheets.",
            icon: "rectangle.split.3x1",
            nodeIdentifier: "hotspot_betaSheet",
            position: SCNVector3(1.0, 5.0, 1.0)
        ),
        EducationalStop(
            id: 5,
            title: "Disulfide Bridge",
            description: "Strong bonds that lock a protein's shape in place.",
            detail: "When two cysteine amino acids come close together in 3D space, their sulfur atoms can form a strong covalent bond called a disulfide bridge. These molecular \"staples\" are critical for stabilizing protein shapes, especially in harsh environments. Insulin, for example, depends on disulfide bridges to maintain the exact shape needed to regulate blood sugar.",
            icon: "bolt.fill",
            nodeIdentifier: "hotspot_disulfide",
            position: SCNVector3(-2.0, 5.0, 0)
        ),
        EducationalStop(
            id: 6,
            title: "Hydrophobic Core",
            description: "The oily interior that drives protein folding.",
            detail: "Amino acids with oily, water-repelling (hydrophobic) side chains cluster together in the protein's interior, hiding from water. This \"hydrophobic effect\" is the single most important force driving protein folding. It determines the protein's overall 3D shape, which in turn determines what the protein can do.",
            icon: "drop.fill",
            nodeIdentifier: "hotspot_hydrophobicCore",
            position: SCNVector3(0.5, 4.0, -2.0)
        ),
        EducationalStop(
            id: 7,
            title: "Tertiary Structure",
            description: "The final 3D shape that gives a protein its function.",
            detail: "The tertiary structure is the complete three-dimensional fold of a single protein chain, determined by all the interactions between side chains: hydrogen bonds, ionic bonds, disulfide bridges, and hydrophobic packing. If a protein unfolds (denatures) due to heat or pH changes, it usually loses its function \u{2014} this is why cooking an egg turns it white and firm.",
            icon: "cube.transparent.fill",
            nodeIdentifier: "hotspot_tertiary",
            position: SCNVector3(1.0, 9.0, 0.5)
        ),
    ]
}
