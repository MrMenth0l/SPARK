import SwiftUI

struct ReturnToThisSection: View {
    let items: [ResurfacedItem]
    var onOpen: (ResurfacedItem) -> Void
    var onDismiss: (ResurfacedItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.medium) {
            SectionHeader(title: "Return to This")
            ForEach(items) { item in
                ReturnToThisCard(
                    item: item,
                    onOpen: { onOpen(item) },
                    onBuild: { onOpen(item) },
                    onDismiss: { onDismiss(item) }
                )
            }
        }
    }
}
