import SwiftUI

struct SparkFeedHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.medium) {
            Text("Discover")
                .font(TypographyTokens.display)
                .foregroundStyle(ColorTokens.primaryText)
            Text("A wider studio of artifacts, cases, patterns, contrasts, and collisions. Browse by family, then follow the one that gives you something to answer.")
                .font(TypographyTokens.note)
                .foregroundStyle(ColorTokens.secondaryText)
        }
    }
}
