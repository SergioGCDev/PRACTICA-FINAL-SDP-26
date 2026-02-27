//
//  LibraryCard.swift
//  Tankodex
//
//  Created by Sergio García on 26/2/26.
//


//
//  LibraryCard.swift
//  Tankodex
//
//  Created by Sergio García on 26/2/26.
//

import SwiftUI

/// Tarjeta expandida para iPad que muestra portada, estado y progreso de colección de un manga de la biblioteca.
struct LibraryCard: View {
    /// Entrada de la colección que se representa en la tarjeta.
    let item: MangaCollectionDTO

    private var collectionProgress: Double? {
        guard let total = item.totalVolumes, total > 0 else { return nil }
        return min(Double(item.volumesBought) / Double(total), 1.0)
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Portada
            AsyncImage(url: URL(string: item.coverURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Rectangle()
                    .foregroundStyle(.secondary.opacity(0.2))
                    .overlay { ProgressView() }
            }
            .frame(width: 80, height: 120)
            .clipped()
            .clipShape(.rect(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Label(item.status.rawValue, systemImage: item.status.icon)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("Reading vol. \(item.currentVolume)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text("Owned: \(item.volumesBought) vols.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                if item.status == .collected, let progress = collectionProgress {
                    VStack(alignment: .leading, spacing: 2) {
                        ProgressView(value: progress)
                            .tint(progress == 1.0 ? .green : .blue)
                        Text("\(Int(progress * 100))% collected")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if item.isCompleted {
                    Label("Complete collection", systemImage: "checkmark.seal.fill")
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }
            
            Spacer()
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(.regularMaterial)
        .clipShape(.rect(cornerRadius: 12))
    }
}