import SwiftUI

struct MoleculeView: View {
    var atoms: [(position: CGPoint, color: Color, size: CGFloat)]
    var bonds: [(from: Int, to: Int)]

    var body: some View {
        Canvas { context, size in
            // Draw bonds
            for bond in bonds {
                guard bond.from < atoms.count, bond.to < atoms.count else { continue }
                let fromAtom = atoms[bond.from]
                let toAtom = atoms[bond.to]
                var path = Path()
                path.move(to: fromAtom.position)
                path.addLine(to: toAtom.position)
                context.stroke(path, with: .color(.white.opacity(0.4)), lineWidth: 2)
            }
            // Draw atoms
            for atom in atoms {
                let rect = CGRect(
                    x: atom.position.x - atom.size / 2,
                    y: atom.position.y - atom.size / 2,
                    width: atom.size,
                    height: atom.size
                )
                context.fill(Path(ellipseIn: rect), with: .color(atom.color))
            }
        }
    }
}

struct FloatingMolecule: View {
    var color: Color = .dnaTeal
    var size: CGFloat = 30

    @State private var offset: CGSize = .zero

    var body: some View {
        ZStack {
            Circle()
                .fill(color.opacity(0.6))
                .frame(width: size * 0.6, height: size * 0.6)
                .offset(x: -size * 0.3, y: -size * 0.2)
            Circle()
                .fill(color.opacity(0.8))
                .frame(width: size * 0.4, height: size * 0.4)
                .offset(x: size * 0.2, y: size * 0.1)
            // Bond
            Path { path in
                path.move(to: CGPoint(x: -size * 0.1, y: -size * 0.05))
                path.addLine(to: CGPoint(x: size * 0.15, y: size * 0.05))
            }
            .stroke(color.opacity(0.4), lineWidth: 1.5)
        }
        .frame(width: size, height: size)
        .offset(offset)
        .onAppear {
            withAnimation(
                .easeInOut(duration: Double.random(in: 2...4))
                .repeatForever(autoreverses: true)
            ) {
                offset = CGSize(
                    width: CGFloat.random(in: -10...10),
                    height: CGFloat.random(in: -15...5)
                )
            }
        }
    }
}
