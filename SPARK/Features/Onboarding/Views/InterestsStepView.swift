import SwiftUI

struct InterestsStepView: View {
    let selected: [InterestDomain]
    let toggle: (InterestDomain) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.large) {
            Text("What worlds stimulate your thinking?")
                .font(TypographyTokens.sectionTitle)
                .foregroundStyle(ColorTokens.primaryText)
            Text("Choose at least 3.")
                .font(TypographyTokens.body)
                .foregroundStyle(ColorTokens.secondaryText)
            SelectionGrid(items: InterestDomain.allCases) { interest in
                Button(action: { toggle(interest) }) {
                    InterestChip(title: interest.title, isSelected: selected.contains(interest))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
