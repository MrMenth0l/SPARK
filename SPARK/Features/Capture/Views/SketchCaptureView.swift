import PencilKit
import SwiftUI

private struct SketchCanvas: UIViewRepresentable {
    @Binding var drawing: PKDrawing

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawingPolicy = .anyInput
        canvasView.backgroundColor = .clear
        canvasView.tool = PKInkingTool(.pen, color: .init(red: 0.18, green: 0.16, blue: 0.14, alpha: 1), width: 4)
        canvasView.delegate = context.coordinator
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if uiView.drawing != drawing {
            uiView.drawing = drawing
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(drawing: $drawing)
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        @Binding var drawing: PKDrawing

        init(drawing: Binding<PKDrawing>) {
            _drawing = drawing
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            drawing = canvasView.drawing
        }
    }
}

struct SketchCaptureView: View {
    @Bindable var viewModel: SketchCaptureViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.medium) {
            StudioKicker(title: "Sketch")
            StudioPanel(style: .archival, accent: ColorTokens.accentSoft, accentEdge: .top, padding: SpacingTokens.medium) {
                SketchCanvas(drawing: $viewModel.drawing)
                    .frame(minHeight: 280)
                    .background(
                        RoundedRectangle(cornerRadius: RadiusTokens.card, style: .continuous)
                            .fill(ColorTokens.page)
                    )
            }
            StudioPanel(style: .archival, padding: nil) {
                TextField("Optional note beneath the sketch", text: $viewModel.note)
                    .font(TypographyTokens.note)
                    .foregroundStyle(ColorTokens.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
            }
            SketchToolbar(
                onClear: {
                    viewModel.drawing = PKDrawing()
                    viewModel.note = ""
                },
                onSave: viewModel.saveCurrentSketch
            )
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(TypographyTokens.footnote)
                    .foregroundStyle(ColorTokens.warning)
            }
        }
    }
}
