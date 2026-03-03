struct LoadingAnimatedIcon: View {
    let isAnimating: Bool

    var body: some View {
        ZStack {
            Circle()
                .fill(.white.opacity(0.2))
                .frame(width: 120, height: 120)
            // Sustituye por tu icono cuando lo tengas
            Image(systemName: "book.stack.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundStyle(.white)
                .scaleEffect(isAnimating ? 1.05 : 0.95)
                .animation(
                    .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                    value: isAnimating
                )
        }
    }
}