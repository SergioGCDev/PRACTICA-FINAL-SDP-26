//
//  PublicationStatusTag.swift
//  Tankodex
//
//  Created by Sergio García on 3/3/26.
//

import SwiftUI

struct PublicationStatusTag: View {
    let status: MangaStatus

    private var label: String {
        switch status {
        case .finished, .discontinued: return "Finished"
        case .publishing, .onHiatus:   return "Ongoing"
        case .none:                    return "Unknown"
        }
    }

    private var color: Color {
        switch status {
        case .publishing, .onHiatus:   return .orange
        case .finished, .discontinued: return .green
        case .none:                    return .gray
        }
    }

    var body: some View {
        Text(label)
            .font(.caption2)
            .fontWeight(.medium)
            .foregroundStyle(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color.opacity(0.85), in: Capsule())
    }
}

#Preview {
    HStack {
        PublicationStatusTag(status: .publishing)
        PublicationStatusTag(status: .finished)
        PublicationStatusTag(status: .discontinued)
        PublicationStatusTag(status: .onHiatus)
        PublicationStatusTag(status: .none)
    }
    .padding()
}
