import SwiftUI

struct OnboardingContainerView: View {
    @State private var viewModel: OnboardingViewModel
    var onComplete: (UserProfile) -> Void

    init(container: AppContainer, onComplete: @escaping (UserProfile) -> Void) {
        _viewModel = State(initialValue: OnboardingViewModel(container: container))
        self.onComplete = onComplete
    }

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.large) {
            OnboardingProgressView(progress: viewModel.progress)
                .padding(.top, SpacingTokens.medium)

            Group {
                switch viewModel.state.step {
                case .welcome:
                    WelcomeStepView()
                case .interests:
                    InterestsStepView(selected: viewModel.state.selectedInterests, toggle: viewModel.toggleInterest)
                case .intentions:
                    IntentionsStepView(selected: viewModel.state.selectedIntents, toggle: viewModel.toggleIntent)
                case .thinkingMode:
                    ThinkingModeStepView(
                        selectedMode: viewModel.state.preferredMode,
                        selectedRhythm: viewModel.state.creativeRhythm,
                        selectMode: viewModel.selectMode,
                        selectRhythm: viewModel.selectRhythm
                    )
                case .complete:
                    OnboardingCompleteView(state: viewModel.state)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

            HStack {
                if viewModel.state.step != .welcome {
                    SPARKButton(title: "Back", variant: .secondary, action: viewModel.goBack)
                        .frame(maxWidth: 120)
                }
                Spacer()
                SPARKButton(title: viewModel.state.step == .complete ? "Enter SPARK" : "Continue") {
                    if viewModel.state.step == .complete {
                        if let profile = try? viewModel.finish() {
                            onComplete(profile)
                        }
                    } else {
                        viewModel.goForward()
                    }
                }
                .opacity(viewModel.canContinue ? 1 : 0.45)
                .disabled(!viewModel.canContinue)
            }
            .padding(.bottom, SpacingTokens.medium)
        }
        .padding(.horizontal, SpacingTokens.medium)
        .sparkScreenBackground()
    }
}
