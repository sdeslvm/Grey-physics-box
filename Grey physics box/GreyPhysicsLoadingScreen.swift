import SwiftUI

// MARK: - Протоколы для улучшения расширяемости

protocol ProgressDisplayable {
    var progressPercentage: Int { get }
}

protocol BackgroundProviding {
    associatedtype BackgroundContent: View
    func makeBackground() -> BackgroundContent
}

// MARK: - Новый фон

struct GreyPhysicsBackground: View, BackgroundProviding {
    func makeBackground() -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#232526"), // dark blue-grey
                Color(hex: "#414345"), // mid grey
                Color(hex: "#6a11cb"), // violet
                Color(hex: "#2575fc"), // blue
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    var body: some View {
        makeBackground()
    }
}

// MARK: - Новый прогресс-бар

struct GreyPhysicsLinearProgressBar: View {
    let progress: Double

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geo.size.height / 2)
                    .fill(Color.white.opacity(0.08))
                RoundedRectangle(cornerRadius: geo.size.height / 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(hex: "#6a11cb"),
                                Color(hex: "#2575fc"),
                                Color(hex: "#43e97b"),
                                Color(hex: "#38f9d7")
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: max(geo.size.width * CGFloat(max(0, min(1, progress))), geo.size.height))
                    .animation(.easeInOut(duration: 0.6), value: progress)
            }
        }
        .frame(height: 18)
        .shadow(color: Color.black.opacity(0.10), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Основной overlay

struct GreyPhysicsLoadingOverlay: View, ProgressDisplayable {
    let progress: Double
    var progressPercentage: Int { Int(progress * 100) }

    var body: some View {
        ZStack {
            GreyPhysicsBackground()
            VStack(spacing: 32) {
                // Новый прогресс-бар
                GreyPhysicsLinearProgressBar(progress: progress)
                    .frame(width: 220, height: 18)
                    .padding(.top, 40)

                VStack(spacing: 8) {
                    Text("Loading...")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 1)

                    Text("\(progressPercentage)%")
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.black.opacity(0.18))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.25), Color.clear]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ), lineWidth: 1)
                )
                .cornerRadius(14)
            }
        }
    }
}

// MARK: - Previews

#if canImport(SwiftUI)
import SwiftUI
#endif

@available(iOS 17.0, *)
#Preview("Vertical") {
    GreyPhysicsLoadingOverlay(progress: 0.2)
}

@available(iOS 17.0, *)
#Preview("Horizontal", traits: .landscapeRight) {
    GreyPhysicsLoadingOverlay(progress: 0.2)
}

// Fallback previews for iOS < 17
struct GreyPhysicsLoadingOverlay_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GreyPhysicsLoadingOverlay(progress: 0.2)
                .previewDisplayName("Vertical (Legacy)")

            GreyPhysicsLoadingOverlay(progress: 0.2)
                .previewDisplayName("Horizontal (Legacy)")
                .previewLayout(.fixed(width: 812, height: 375))
        }
    }
}

// ...existing code for Color(hex:) extension if present...
