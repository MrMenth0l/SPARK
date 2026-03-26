import SwiftUI

struct AttachmentsSection: View {
    let attachments: [Attachment]

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.small) {
            ForEach(attachments, id: \.id) { attachment in
                SPARKCard {
                    switch attachment {
                    case .voice(let voice):
                        VStack(alignment: .leading, spacing: 8) {
                            StudioKicker(title: "Voice note")
                            Text("\(Int(voice.duration))s recording")
                                .font(TypographyTokens.caption)
                                .foregroundStyle(ColorTokens.tertiaryText)
                            if let transcription = voice.transcription, !transcription.isBlank {
                                Text(transcription)
                                    .font(TypographyTokens.note)
                                    .foregroundStyle(ColorTokens.primaryText)
                            }
                        }
                    case .sketch(let sketch):
                        VStack(alignment: .leading, spacing: 8) {
                            StudioKicker(title: "Sketch")
                            Text(sketch.note?.isBlank == false ? sketch.note! : "Freeform jot")
                                .font(TypographyTokens.note)
                                .foregroundStyle(ColorTokens.secondaryText)
                        }
                    }
                }
            }
        }
    }
}
