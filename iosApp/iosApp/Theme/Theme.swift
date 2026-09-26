import SwiftUI
import UIKit

/// Builds a Color that resolves per trait environment, so it follows
/// `.preferredColorScheme` app-wide without any call site needing to know
/// which scheme is active.
private func adaptive(dark: (Double, Double, Double), light: (Double, Double, Double)) -> Color {
    Color(uiColor: UIColor { traits in
        let (r, g, b) = traits.userInterfaceStyle == .dark ? dark : light
        return UIColor(red: r, green: g, blue: b, alpha: 1)
    })
}

/// Design tokens for BR Explorer. Palette references the legacy BR mark's red
/// and a railway signal-light vocabulary (green/amber/red) for live status.
/// Dark is the legacy-matched default; light swaps ink/surface/text polarity
/// while keeping the same accent hues.
enum BRColor {
    static let ink = adaptive(dark: (0.043, 0.051, 0.063), light: (0.973, 0.969, 0.957))        // #0B0D10 / #F8F7F4
    static let surface = adaptive(dark: (0.082, 0.098, 0.125), light: (0.937, 0.933, 0.914))     // #151920 / #EFEEE9
    static let surfaceRaised = adaptive(dark: (0.110, 0.129, 0.161), light: (1.0, 1.0, 1.0))     // #1C2129 / #FFFFFF
    static let hairline = adaptive(dark: (0.149, 0.169, 0.200), light: (0.859, 0.851, 0.827))    // #262B33 / #DBD9D3
    static let rail = Color(red: 0.839, green: 0.161, blue: 0.243)        // #D6293E — fixed brand accent
    static let signalAmber = Color(red: 0.910, green: 0.639, blue: 0.239) // #E8A33D — fixed
    static let signalGreen = Color(red: 0.239, green: 0.667, blue: 0.435) // #3DAA6E — fixed
    static let textPrimary = adaptive(dark: (0.949, 0.941, 0.918), light: (0.086, 0.094, 0.106)) // #F2F0EA / #16181B
    static let textSecondary = adaptive(dark: (0.545, 0.565, 0.604), light: (0.408, 0.420, 0.443)) // #8B909A / #686B71
    /// Fixed near-black — for text/icons drawn on the red accent, which needs
    /// the same contrast regardless of the active app-wide scheme.
    static let onAccent = Color(red: 0.055, green: 0.055, blue: 0.055)
}

enum BRFont {
    /// Editorial serif for headlines/greetings — deliberately not system grotesk.
    static func display(_ size: CGFloat, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .serif)
    }
    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .default)
    }
    /// Tabular monospaced digits for all real data: times, fares, train numbers, phone.
    static func data(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .monospaced)
    }
}

/// Railway signal semantics: green = on time, amber = delayed, red = alert.
enum SignalStatus: Hashable {
    case onTime, delayed, alert

    var color: Color {
        switch self {
        case .onTime: return BRColor.signalGreen
        case .delayed: return BRColor.signalAmber
        case .alert: return BRColor.rail
        }
    }

    var label: String {
        switch self {
        case .onTime: return "On time"
        case .delayed: return "Delayed"
        case .alert: return "Alert"
        }
    }
}

struct SignalDot: View {
    let status: SignalStatus
    var pulsing: Bool = false
    @State private var animate = false

    var body: some View {
        Circle()
            .fill(status.color)
            .frame(width: 8, height: 8)
            .overlay(
                Circle()
                    .stroke(status.color.opacity(0.4), lineWidth: pulsing ? 4 : 0)
                    .scaleEffect(animate ? 1.8 : 1)
                    .opacity(animate ? 0 : 1)
            )
            .onAppear {
                guard pulsing else { return }
                withAnimation(.easeOut(duration: 1.4).repeatForever(autoreverses: false)) {
                    animate = true
                }
            }
    }
}

/// Dashed ticket-perforation rule — used only where content is literally a
/// ticket/fare line item, not as generic decoration.
struct PerforatedDivider: View {
    var body: some View {
        Rectangle()
            .fill(BRColor.hairline)
            .frame(height: 1)
            .overlay(
                Rectangle()
                    .fill(BRColor.hairline)
                    .frame(height: 1)
                    .mask(
                        HStack(spacing: 4) {
                            ForEach(0..<60, id: \.self) { _ in
                                Rectangle().frame(width: 3)
                            }
                        }
                    )
            )
    }
}

struct BRPrimaryButtonStyle: ButtonStyle {
    var isLoading: Bool = false
    var isEnabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 8) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(BRColor.onAccent)
            }
            configuration.label
                .font(BRFont.body(16, weight: .semibold))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .foregroundStyle(BRColor.onAccent)
        .background(isEnabled ? BRColor.rail : BRColor.rail.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .opacity(configuration.isPressed ? 0.85 : 1)
    }
}

struct BRSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(BRFont.body(15, weight: .medium))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .foregroundStyle(BRColor.textPrimary)
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(BRColor.hairline, lineWidth: 1)
            )
            .contentShape(Rectangle())
            .opacity(configuration.isPressed ? 0.7 : 1)
    }
}

struct BRCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 0) { content }
            .background(BRColor.surfaceRaised)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(BRColor.hairline, lineWidth: 1)
            )
    }
}
