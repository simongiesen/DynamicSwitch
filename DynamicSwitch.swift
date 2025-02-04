import SwiftUI

struct DynamicSwitch: View {
    var options: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        ZStack {
            // Hintergrund mit Blur und Schatten
            RoundedRectangle(cornerRadius: 25)
                .fill(Color(.systemGray5).opacity(0.5))
                .blur(radius: 10)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Hervorhebungsindikator für das ausgewählte Segment
            GeometryReader { geometry in
                let segmentWidth = geometry.size.width / CGFloat(options.count)
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white.opacity(0.3))
                    .frame(width: segmentWidth, height: geometry.size.height)
                    .offset(x: CGFloat(selectedIndex) * segmentWidth)
                    .animation(.easeInOut, value: selectedIndex)
            }
            
            // Dynamische Anzeige der Optionen
            HStack(spacing: 0) {
                ForEach(options.indices, id: \.self) { index in
                    Text(options[index])
                        .fontWeight(.bold)
                        .foregroundColor(selectedIndex == index ? .black : .gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle()) // Damit der ganze Bereich anklickbar ist
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedIndex = index
                            }
                        }
                }
            }
        }
        .frame(height: 40)
        .background(BlurView(style: .systemUltraThinMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    }
}

struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}

struct ContentView: View {
    @State private var selectedIndex = 0
    let options = ["Standard", "Satellite", "Hybrid"]

    var body: some View {
        VStack {
            DynamicSwitch(options: options, selectedIndex: $selectedIndex)
                .padding()
            
            Text("Ausgewählte Option: \(options[selectedIndex])")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
