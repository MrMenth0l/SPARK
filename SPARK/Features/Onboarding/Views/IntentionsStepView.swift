import SwiftUI

struct IntentionsStepView: View {
    let selected: [CreativeIntent]
    let toggle: (CreativeIntent) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.large) {
            Text("What kind of creative growth are you seeking right now?")
                .font(TypographyTokens.sectionTitle)
                .foregroundStyle(ColorTokens.primaryText)
            Text("Choose up to 4.")
                .font(TypographyTokens.body)
                .foregroundStyle(ColorTokens.secondaryText)
            SelectionGrid(items: CreativeIntent.allCases) { intent in
                Button(action: { toggle(intent) }) {
                    InterestChip(title: intent.title, isSelected: selected.contains(intent))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
