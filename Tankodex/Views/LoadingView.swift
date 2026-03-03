//
//  SplashView.swift
//  Tankodex
//
//  Created by Sergio García on 2/3/26.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var showMessage = false

    // TODO: LocalizedStringKey para implementar localizations
    let message: LocalizedStringKey

    init(message: LocalizedStringKey = "Loading collection...") {
        self.message = message
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.accentColor.opacity(0.8),
                    Color.accentColor.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer()

                LoadingAnimatedIcon(isAnimating: isAnimating)

                LoadingMessage(message: message, showSubtitle: showMessage)

                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                    .scaleEffect(1.5)
                    .padding(.top, 20)

                Spacer()

                LoadingBranding()
            }
        }
        .onAppear {
            withAnimation {
                isAnimating = true
            }
            Task {
                try? await Task.sleep(for: .seconds(2))
                withAnimation {
                    showMessage = true
                }
            }
        }
    }
}

// MARK: - Previews

#Preview {
    LoadingView()
}

#Preview("Custom message") {
    LoadingView(message: "Loading your library...")
}
