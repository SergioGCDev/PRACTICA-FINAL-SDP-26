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
    case all = "All"
    
        // MARK: - UI Properties
    
    var color: Color {
        switch self {
        case .shounen:
            return .blue
        case .shoujo:
            return .pink
        case .seinen:
            return .indigo
        case .josei:
            return .purple
        case .kids:
            return .green
        case .all:
            return .gray

        }
    }
    
    var emoji: String {
        switch self {
        case .shounen:
            return "👦🏻"
        case .shoujo:
            return "👧🏻"
        case .seinen:
            return "🧔🏻‍♂️"
        case .josei:
            return "👩🏻‍🦱"
        case .kids:
            return "👶🏻"
        case .all:
            return "👤"
        }
    }
    
    var icon: String {
            switch self {
            case .all:     return "square.grid.2x2"
            case .shounen: return "bolt"
            case .shoujo:  return "heart"
            case .seinen:  return "brain"
            case .josei:   return "sparkles"
            case .kids:    return "star"
            }
        }
}
