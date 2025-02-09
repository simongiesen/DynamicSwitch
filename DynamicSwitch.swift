//
//  DynamicSwitch.swift
//  StubenFuchs
//
//  Created by Simon Giesen on 04.02.25.
//
import SwiftUI

struct DynamicSwitch: View {
    var options: [String]
    @Binding var selectedIndex: Int

    var body: some View {
        ZStack {
            // Hintergrund mit Blur und Schatten
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray5).opacity(0.5))
                .blur(radius: 10)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // Hervorhebungsindikator für das ausgewählte Segment
            GeometryReader { geometry in
                let segmentWidth = geometry.size.width / CGFloat(options.count)
                RoundedRectangle(cornerRadius: 15)
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
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
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
