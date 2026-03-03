//
//  LoadingBranding.swift
//  Tankodex
//
//  Created by Sergio García on 2/3/26.
//

import SwiftUI

struct LoadingBranding: View {
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                Text("TANK")
                Text("Õ")
                    .foregroundColor(.tankodexSecondary)
                Text("DEX")
            }
            .font(.headline)
            .fontWeight(.bold)
            .tracking(2)
            .foregroundStyle(.white)
            Text("Your manga collection")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(.bottom, 40)
    }
}
