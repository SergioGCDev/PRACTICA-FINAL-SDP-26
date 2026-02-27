//
//  LibraryRow.swift
//  Tankodex
//
//  Created by Sergio García on 23/2/26.
//

import SwiftUI

/// Fila compacta para iPhone que muestra portada, volumen actual y progreso de colección de un manga de la biblioteca.
struct LibraryRow: View {
    /// Entrada de la colección que se representa en la fila.
    let item: MangaCollectionDTO

    private var collectionProgress: Double? {
        guard let total = item.totalVolumes, total > 0 else { return nil }
        return Double(item.volumesBought) / Double(total)
    }
    
    var body: some View {
        HStack {
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
            .frame(width: 50, height: 75)
            .clipped()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text("Reading vol. \(item.currentVolume)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("Owned: \(item.volumesBought) vols.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                // Progress bar solo para Collected
                if item.status == .collected, let progress = collectionProgress {
                    VStack(alignment: .leading, spacing: 2) {
                        ProgressView(value: progress)
                            .tint(progress == 1.0 ? .green : .blue)
                        Text("\(Int(progress * 100))% collected")
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                if item.isCompleted {
                    Label("Complete collection", systemImage: "checkmark.seal.fill")
                        .font(.caption2)
                        .foregroundStyle(.green)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
