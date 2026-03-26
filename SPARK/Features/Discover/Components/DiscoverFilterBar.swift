import SwiftUI

struct DiscoverFilterBar: View {
    @Binding var state: DiscoverFilterState

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            VStack(alignment: .leading, spacing: SpacingTokens.small) {
                HStack(spacing: SpacingTokens.small) {
                    ForEach(StimulusFamily.allCases) { family in
                        Button(action: {
                            state.selectedFamily = state.selectedFamily == family ? nil : family
                        }) {
                            SparkFamilyPill(family: family, isSelected: state.selectedFamily == family)
                        }
                        .buttonStyle(.plain)
                    }
                }
                HStack(spacing: SpacingTokens.small) {
                    ForEach(InterestDomain.allCases.prefix(8)) { domain in
                        Button(action: {
                            state.selectedDomain = state.selectedDomain == domain ? nil : domain
                        }) {
                            Chip(title: domain.title, isSelected: state.selectedDomain == domain)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
