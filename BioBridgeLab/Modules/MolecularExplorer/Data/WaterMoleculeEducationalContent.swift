import SceneKit

struct WaterMoleculeEducationalContent {
    static let stops: [EducationalStop] = [
        EducationalStop(
            id: 0,
            title: "Oxygen Atom",
            description: "The electronegative heart of the water molecule.",
            detail: "Oxygen has six valence electrons and needs two more to complete its outer shell. By sharing electrons with two hydrogen atoms, it forms a stable molecule\u{2014}but oxygen pulls the shared electrons closer to itself because of its high electronegativity (3.44 on the Pauling scale), creating an unequal charge distribution.",
            icon: "circle.fill",
            nodeIdentifier: "hotspot_oxygen",
            position: SCNVector3(0, 1.5, 0)
        ),
        EducationalStop(
            id: 1,
            title: "Hydrogen Atoms",
            description: "Two small atoms bonded to oxygen.",
            detail: "Each hydrogen atom contributes one electron to a covalent bond with oxygen. Because hydrogen has a much lower electronegativity (2.20), the shared electrons spend more time near the oxygen, giving each hydrogen a slight positive charge (\u{03B4}+). This asymmetry is what makes water a polar molecule.",
            icon: "circle",
            nodeIdentifier: "hotspot_hydrogen",
            position: SCNVector3(-0.95, 2.23, 0)
        ),
        EducationalStop(
            id: 2,
            title: "Covalent Bonds",
            description: "Shared electron pairs holding the molecule together.",
            detail: "The two O\u{2013}H bonds in water are polar covalent bonds, each about 0.96 angstroms long. These are among the strongest intramolecular bonds in nature, requiring 459 kJ/mol to break. This bond strength is part of why water is so chemically stable and difficult to decompose.",
            icon: "link",
            nodeIdentifier: "hotspot_covalentBond",
            position: SCNVector3(-0.48, 1.87, 0)
        ),
        EducationalStop(
            id: 3,
            title: "104.5\u{00B0} Bond Angle",
            description: "The bent shape that makes water special.",
            detail: "Water is not linear\u{2014}the two hydrogen atoms sit at a 104.5\u{00B0} angle rather than 180\u{00B0}. This bent geometry is caused by the two lone pairs of electrons on oxygen, which repel the bonding pairs according to VSEPR theory. Without this bend, water would be nonpolar and life as we know it could not exist.",
            icon: "angle",
            nodeIdentifier: "hotspot_bondAngle",
            position: SCNVector3(0, 2.0, 0)
        ),
        EducationalStop(
            id: 4,
            title: "Polar Molecule",
            description: "An uneven distribution of electrical charge.",
            detail: "The bent shape and unequal electron sharing give water a permanent dipole: the oxygen side carries a partial negative charge (\u{03B4}\u{2212}) and the hydrogen side carries a partial positive charge (\u{03B4}+). This polarity makes water an extraordinary solvent, able to dissolve more substances than any other common liquid\u{2014}earning it the title \"universal solvent.\"",
            icon: "plus.forwardslash.minus",
            nodeIdentifier: "hotspot_polarity",
            position: SCNVector3(1.6, 1.5, 0)
        ),
        EducationalStop(
            id: 5,
            title: "Hydrogen Bonding",
            description: "Weak attractions between neighboring water molecules.",
            detail: "The \u{03B4}+ hydrogen of one water molecule is attracted to the \u{03B4}\u{2212} oxygen of a neighboring molecule, forming a hydrogen bond. Each water molecule can form up to four hydrogen bonds. Though individually weak, these bonds collectively give water its high boiling point, surface tension, and ability to moderate temperature\u{2014}properties essential for life on Earth.",
            icon: "arrow.triangle.branch",
            nodeIdentifier: "hotspot_hydrogenBond",
            position: SCNVector3(-1.0, 1.0, 0)
        ),
    ]
}
