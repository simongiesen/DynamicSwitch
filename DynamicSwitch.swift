import SwiftUI

struct DynamicSwitch: View {
    var options: [String]
    @Binding var selectedIndex: Int
    
    var body: some View {
        ZStack {
            // Basis-Container
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground).opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                )
            
            // Auswahlindikator
            GeometryReader { geometry in
                let segmentWidth = geometry.size.width / CGFloat(options.count)
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: segmentWidth - 8, height: geometry.size.height - 8)
                    .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                    .offset(x: 4 + CGFloat(selectedIndex) * segmentWidth)
                    .animation(.easeInOut(duration: 0.2), value: selectedIndex)
            }
            
            // Text-Optionen
            HStack(spacing: 0) {
                ForEach(options.indices, id: \.self) { index in
                    Text(options[index])
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(selectedIndex == index ? Color.black : Color.black.opacity(0.5))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedIndex = index
                            }
                        }
                }
            }
        }
        .frame(height: 32)
        .background(
            BackgroundBlurView(style: .systemThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        )
    }
}

// Optimierter BlurView für bessere Performance
struct BackgroundBlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// Vorschau
struct DynamicSwitch_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.opacity(0.3).edgesIgnoringSafeArea(.all)
            DynamicSwitch(options: ["Satellite", "Standard"], selectedIndex: .constant(0))
                .frame(width: 200)
        }
    }
}
