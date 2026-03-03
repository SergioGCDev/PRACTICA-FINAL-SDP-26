//
//  LoadingAnimatedIcon.swift
//  Tankodex
//
//  Created by Sergio García on 2/3/26.
//

import SwiftUI

struct LoadingAnimatedIcon: View {
    let isAnimating: Bool

    var body: some View {
        ZStack {
            Image("swifgeyLS")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundStyle(.white)
                .scaleEffect(isAnimating ? 1.05 : 0.95)
                .animation(
                    .easeInOut(duration: 1.2).repeatForever(autoreverses: true),
                    value: isAnimating
                )
        }
    }
}

#Preview {
    LoadingAnimatedIcon(isAnimating: true)
}
