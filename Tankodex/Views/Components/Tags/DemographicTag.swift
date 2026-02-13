    //
    //  DemographicTag.swift
    //  Tankodex
    //
    //  Created by Sergio García on 10/2/26.
    //

import SwiftUI

struct DemographicTag: View {
    let demographic: Demographic
    let style: Style
    
    enum Style {
        case withText
        case emoji
    }
    var body: some View {
        switch style {
        case .withText:
            emojiText
        case .emoji:
            onlyEmoji
        }
    }
    
        // MARK: - Subviews
    
    private var emojiText: some View {
        HStack(spacing: 4) {
            Text(demographic.emoji)
                .font(.caption)
            Text(demographic.rawValue)
                .font(.caption2)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(demographic.color)
        .foregroundStyle(.white)
        .clipShape(Capsule())
    }
    
    private var onlyEmoji: some View {
        Text(demographic.emoji)
            .font(.title3)
            .padding(8)
            .background(demographic.color.opacity(0.2))
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(demographic.color, lineWidth: 2)
            }
    }
}

#Preview {
    VStack(spacing: 16) {
            // Full style
        VStack(spacing: 8) {
            Text("Full Style (default)")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            DemographicTag(demographic: .shounen, style: .withText)
            DemographicTag(demographic: .shoujo, style: .withText)
            DemographicTag(demographic: .seinen, style: .withText)
        }
        
        Divider()
        
            // Compact style
        VStack(spacing: 8) {
            Text("Compact Style")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                DemographicTag(demographic: .shounen, style: .emoji)
                DemographicTag(demographic: .shoujo, style: .emoji)
                DemographicTag(demographic: .seinen, style: .emoji)
            }
        }
    }
    .padding()
}
