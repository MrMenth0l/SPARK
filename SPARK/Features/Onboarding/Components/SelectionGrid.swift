import SwiftUI

struct SelectionGrid<Data: RandomAccessCollection, Content: View>: View where Data.Element: Identifiable {
    let items: Data
    let content: (Data.Element) -> Content

    private let columns = [GridItem(.adaptive(minimum: 120), spacing: SpacingTokens.small)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: SpacingTokens.small) {
            ForEach(items) { item in
                content(item)
            }
        }
    }
}
