//
//  ThemeDTO.swift
//  Tankodex
//
//  Created by Sergio García on 2/3/26.
//

import Foundation

/// DTO de temas tal y como lo devuelve la API
struct ThemeDTO: Codable, Identifiable {
    let id: UUID
    let theme: String
}

extension ThemeDTO {
    var themeType: Theme? {
        Theme(rawValue: theme)
    }
}

extension ThemeDTO {
    static let preview = ThemeDTO(
        id: UUID(uuidString: "ADC7CBC8-36B9-4E52-924A-4272B7B2CB2C")!,
        theme: "Martial Arts"
    )
}
