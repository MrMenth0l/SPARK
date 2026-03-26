import SwiftUI

struct TodaySparksSection: View {
    let stimuli: [StimulusRecord]
    var onSave: (StimulusRecord) -> Void
    var onRespond: (StimulusRecord) -> Void
    var onBuild: (StimulusRecord) -> Void
    var onOpen: (StimulusRecord) -> Void
    var onSeeMore: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.medium) {
            SectionHeader(title: "Today’s Sparks", actionTitle: "See more in Discover", action: onSeeMore)
            ForEach(stimuli) { stimulus in
                StimulusCard(
                    record: stimulus,
                    onSave: { onSave(stimulus) },
                    onRespond: { onRespond(stimulus) },
                    onBuild: { onBuild(stimulus) },
                    onOpen: { onOpen(stimulus) }
                )
            }
        }
    }
}
