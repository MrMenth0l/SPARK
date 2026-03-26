import SwiftUI

struct LibrarySearchBar: View {
    @Binding var query: String

    var body: some View {
        SearchField(title: "Search ideas, stimuli, drafts", text: $query)
    }
}
