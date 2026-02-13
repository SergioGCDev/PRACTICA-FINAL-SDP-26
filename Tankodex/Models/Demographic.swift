    //
    //  Demographic.swift
    //  Tankodex
    //
    //  Created by Sergio García on 10/2/26.
    //

import SwiftUI

enum Demographic: String, Codable, CaseIterable, Hashable {
    case shounen = "Shounen"
    case shoujo = "Shoujo"
    case seinen = "Seinen"
    case josei = "Josei"
    case kids = "Kids"
    
        // MARK: - UI Properties
    
    var color: Color {
        switch self {
        case .shounen:
            return .blue        // Masculino joven
        case .shoujo:
            return .pink        // Femenino joven
        case .seinen:
            return .indigo      // Masculino adulto
        case .josei:
            return .purple      // Femenino adulto
        case .kids:
            return .green       // Infantil
        }
    }
    
    var emoji: String {
        switch self {
        case .shounen:
            return "👦🏻"  // Chico joven
        case .shoujo:
            return "👧🏻"  // Chica joven
        case .seinen:
            return "🧔🏻‍♂️"  // Hombre adulto
        case .josei:
            return "👩🏻‍🦱"  // Mujer adulta
        case .kids:
            return "👶🏻"  // Bebé/niño pequeño
        }
    }
}
