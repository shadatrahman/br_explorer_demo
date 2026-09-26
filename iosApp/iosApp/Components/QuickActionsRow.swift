import SwiftUI

struct QuickAction: Identifiable {
    let id = UUID()
    let title: String
    let systemImage: String
}

struct QuickActionsRow: View {
    let actions: [QuickAction]
    var onTap: (QuickAction) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 4)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 18) {
            ForEach(actions) { action in
                Button {
                    onTap(action)
                } label: {
                    VStack(spacing: 8) {
                        Image(systemName: action.systemImage)
                            .font(.system(size: 17, weight: .medium))
                            .foregroundStyle(BRColor.textPrimary)
                            .frame(width: 44, height: 44)
                            .background(BRColor.surfaceRaised)
                            .overlay(Circle().stroke(BRColor.hairline, lineWidth: 1))
                            .clipShape(Circle())
                        Text(action.title)
                            .font(BRFont.body(11, weight: .medium))
                            .foregroundStyle(BRColor.textSecondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }
}
