struct LoadingMessage: View {
    let message: LocalizedStringKey
    let showSubtitle: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(message)
                .font(.headline)
                .foregroundStyle(.white)

            if showSubtitle {
                Text("This may take a moment")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
}