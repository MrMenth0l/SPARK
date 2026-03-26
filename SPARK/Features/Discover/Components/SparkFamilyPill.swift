import SwiftUI

struct SparkFamilyPill: View {
    let family: StimulusFamily
    let isSelected: Bool

    var body: some View {
        Chip(title: family.title, isSelected: isSelected, kind: .taxonomy, accent: family.accentColor)
    }
}
