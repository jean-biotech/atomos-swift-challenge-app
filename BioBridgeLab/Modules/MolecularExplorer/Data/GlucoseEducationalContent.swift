import SceneKit

struct GlucoseEducationalContent {
    static let stops: [EducationalStop] = [
        EducationalStop(
            id: 0,
            title: "Pyranose Ring",
            description: "The six-membered ring form of glucose.",
            detail: "In aqueous solution, glucose predominantly exists as a closed ring rather than an open chain. The pyranose ring contains five carbon atoms and one oxygen atom, forming a stable six-membered structure similar to the organic molecule pyran. Over 99% of glucose molecules in solution adopt this ring form at any given time.",
            icon: "hexagon",
            nodeIdentifier: "hotspot_pyranoseRing",
            position: SCNVector3(0, 0, 0)
        ),
        EducationalStop(
            id: 1,
            title: "Carbon Backbone",
            description: "Six carbon atoms forming the molecular skeleton.",
            detail: "Glucose has the molecular formula C\u{2086}H\u{2081}\u{2082}O\u{2086}, with six carbon atoms numbered C1 through C6. Each carbon provides a site for different functional groups to attach, and the specific arrangement of these groups around each carbon is what distinguishes glucose from other simple sugars like galactose or fructose.",
            icon: "point.3.connected.trianglepath.dotted",
            nodeIdentifier: "hotspot_carbonBackbone",
            position: SCNVector3(0, 1.2, 0)
        ),
        EducationalStop(
            id: 2,
            title: "Hydroxyl Groups",
            description: "The -OH groups that make glucose soluble in water.",
            detail: "Multiple hydroxyl groups (-OH) project from the ring, making glucose highly polar and water-soluble. These groups form hydrogen bonds with surrounding water molecules, which is why glucose dissolves so readily in blood plasma. The precise positioning of each hydroxyl group\u{2014}above or below the ring plane\u{2014}determines the sugar's identity and biological activity.",
            icon: "drop",
            nodeIdentifier: "hotspot_hydroxyl",
            position: SCNVector3(0, 2.4, 0)
        ),
        EducationalStop(
            id: 3,
            title: "Alpha vs Beta Glucose",
            description: "Two forms that differ at just one carbon.",
            detail: "When glucose cyclizes, the hydroxyl group on carbon 1 can end up either below the ring plane (alpha, \u{03B1}) or above it (beta, \u{03B2}). This seemingly tiny difference has enormous consequences: alpha-glucose polymerizes into starch (energy storage), while beta-glucose polymerizes into cellulose (structural fiber), which humans cannot digest.",
            icon: "arrow.up.arrow.down.circle",
            nodeIdentifier: "hotspot_alphaBeta",
            position: SCNVector3(0, 3.6, 0)
        ),
        EducationalStop(
            id: 4,
            title: "Glycosidic Bonds",
            description: "The bonds that link glucose units into chains.",
            detail: "When two glucose molecules join, a water molecule is released in a condensation reaction, forming a glycosidic bond between them. Alpha-1,4 glycosidic bonds create starch and glycogen for energy storage, while beta-1,4 glycosidic bonds create cellulose\u{2014}the most abundant organic molecule on Earth and the structural material of plant cell walls.",
            icon: "link",
            nodeIdentifier: "hotspot_glycosidicBond",
            position: SCNVector3(0, 4.8, 0)
        ),
        EducationalStop(
            id: 5,
            title: "Cellular Respiration",
            description: "Breaking down glucose to produce ATP.",
            detail: "Through glycolysis, the Krebs cycle, and oxidative phosphorylation, cells systematically extract energy from glucose and store it in ATP. One molecule of glucose can yield up to 36\u{2013}38 ATP molecules. This three-stage process is why you need both food (glucose) and oxygen\u{2014}and why you exhale carbon dioxide and water as byproducts.",
            icon: "flame.fill",
            nodeIdentifier: "hotspot_cellularRespiration",
            position: SCNVector3(0, 6.0, 0)
        ),
    ]
}
