import SwiftUI

struct WriteCaptureView: View {
    @Bindable var viewModel: CaptureViewModel
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $viewModel.text)
                .font(TypographyTokens.editorBody)
                .foregroundStyle(ColorTokens.primaryText)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .focused($isFocused)
                .onChange(of: viewModel.text) { _, newValue in
                    viewModel.updateText(newValue)
                }
            if viewModel.text.isBlank {
                Text(viewModel.placeholderText)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.tertiaryText)
                    .padding(.top, 8)
                    .padding(.leading, 6)
            }
        }
        .frame(minHeight: 360)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isFocused = true
            }
        }
    }
}
