//
//  LoadingMessage.swift
//  Tankodex
//
//  Created by Sergio García on 2/3/26.
//

import SwiftUI

struct LoadingMessage: View {
    let message: LocalizedStringKey
    let showSubtitle: Bool

    var body: some View {
        VStack(spacing: 8) {
            Text(message)
                .font(.headline)
                .fontDesign(.rounded)
                .foregroundStyle(.white)

            if showSubtitle {
                Text("Almost there!")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
    }
}
