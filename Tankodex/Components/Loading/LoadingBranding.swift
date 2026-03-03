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
            Text("TANKŌDEX")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            Text("Your manga collection")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding(.bottom, 40)
    }
}
