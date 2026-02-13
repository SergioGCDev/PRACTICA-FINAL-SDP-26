//
//  Genre.swift
//  Tankodex
//
//  Created by Sergio García on 12/2/26.
//

import SwiftUI

enum Genre: String, Codable, CaseIterable, Hashable {
    case action = "Action"
    case adventure = "Adventure"
    case awardWinning = "Award Winning"
    case drama = "Drama"
    case fantasy = "Fantasy"
    case horror = "Horror"
    case supernatural = "Supernatural"
    case mystery = "Mystery"
    case sliceOfLife = "Slice of Life"
    case comedy = "Comedy"
    case sciFi = "Sci-Fi"
    case suspense = "Suspense"
    case sports = "Sports"
    case ecchi = "Ecchi"
    case romance = "Romance"
    case girlsLove = "Girls Love"
    case boysLove = "Boys Love"
    case gourmet = "Gourmet"
    case erotica = "Erotica"
    case hentai = "Hentai"
    case avantGarde = "Avant Garde"
    
    // MARK: - UI Properties
    var color: Color {
        switch self {
        case .action:
            return .red
        case .adventure:
            return .orange
        case .awardWinning:
            return .yellow
        case .drama:
            return .purple
        case .fantasy:
            return .pink
        case .horror:
            return Color(red: 0.3, green: 0, blue: 0)  // Rojo oscuro
        case .supernatural:
            return Color(red: 0.5, green: 0, blue: 0.5)  // Morado oscuro
        case .mystery:
            return .indigo
        case .sliceOfLife:
            return .green
        case .comedy:
            return Color(red: 1, green: 0.8, blue: 0)  // Amarillo brillante
        case .sciFi:
            return .cyan
        case .suspense:
            return Color(red: 0.2, green: 0.2, blue: 0.2)  // Gris oscuro
        case .sports:
            return .blue
        case .ecchi:
            return Color(red: 1, green: 0.4, blue: 0.7)  // Rosa claro
        case .romance:
            return Color(red: 1, green: 0.2, blue: 0.5)  // Rosa fuerte
        case .girlsLove:
            return Color(red: 1, green: 0.6, blue: 0.8)  // Rosa pastel
        case .boysLove:
            return Color(red: 0.4, green: 0.6, blue: 1)  // Azul pastel
        case .gourmet:
            return Color(red: 0.8, green: 0.5, blue: 0.2)  // Marrón/naranja
        case .erotica:
            return Color(red: 0.7, green: 0, blue: 0.3)  // Rojo oscuro/rosa
        case .hentai:
            return Color(red: 0.9, green: 0, blue: 0.4)  // Magenta oscuro
        case .avantGarde:
            return Color(red: 0.5, green: 0.5, blue: 0.5)  // Gris
        }
    }
}
