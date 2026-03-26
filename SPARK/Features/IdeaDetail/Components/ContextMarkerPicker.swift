import SwiftUI

struct ContextMarkerPicker: View {
    let selectedMarker: String?
    var onSelect: (String?) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.small) {
            SectionHeader(title: "Lens")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: SpacingTokens.small) {
                    Button(action: { onSelect(nil) }) {
                        Chip(title: "None", isSelected: selectedMarker == nil, kind: .quiet, accent: ColorTokens.accent)
                    }
                    .buttonStyle(.plain)
                    ForEach(Constants.contextMarkers, id: \.self) { marker in
                        Button(action: { onSelect(marker) }) {
                            Chip(title: marker, isSelected: selectedMarker == marker, kind: .filter, accent: ColorTokens.accent)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}
