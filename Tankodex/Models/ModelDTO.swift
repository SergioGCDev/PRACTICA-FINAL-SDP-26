//
//  ModelDTO.swift
//  myMangas
//
//  Created by Sergio García on 22/12/25.
//

import Foundation

// MARK: - Enums / Enumeraciones

/// Temáticas disponibles en la API para clasificar mangas.
enum Theme: String, Codable, CaseIterable {
    case gore = "Gore"
    case military = "Military"
    case mythology = "Mythology"
    case psychological = "Psychological"
    case historical = "Historical"
    case samurai = "Samurai"
    case romanticSubtext = "Romantic Subtext"
    case school = "School"
    case adultCast = "Adult Cast"
    case parody = "Parody"
    case superPower = "Super Power"
    case teamSports = "Team Sports"
    case delinquents = "Delinquents"
    case workplace = "Workplace"
    case survival = "Survival"
    case childcare = "Childcare"
    case iyashikei = "Iyashikei"
    case reincarnation = "Reincarnation"
    case showbiz = "Showbiz"
    case anthropomorphic = "Anthropomorphic"
    case lovePolygon = "Love Polygon"
    case music = "Music"
    case mecha = "Mecha"
    case combatSports = "Combat Sports"
    case isekai = "Isekai"
    case gagHumor = "Gag Humor"
    case crossdressing = "Crossdressing"
    case reverseHarem = "Reverse Harem"
    case martialArts = "Martial Arts"
    case visualArts = "Visual Arts"
    case harem = "Harem"
    case otakuCulture = "Otaku Culture"
    case timeTravel = "Time Travel"
    case videoGame = "Video Game"
    case strategyGame = "Strategy Game"
    case vampire = "Vampire"
    case mahouShoujo = "Mahou Shoujo"
    case highStakesGame = "High Stakes Game"
    case cgdct = "CGDCT"
    case organizedCrime = "Organized Crime"
    case detective = "Detective"
    case performingArts = "Performing Arts"
    case medical = "Medical"
    case space = "Space"
    case memoir = "Memoir"
    case villainess = "Villainess"
    case racing = "Racing"
    case pets = "Pets"
    case magicalSexShift = "Magical Sex Shift"
    case educational = "Educational"
    case idolsFemale = "Idols (Female)"
    case idolsMale = "Idols (Male)"
}

/// Estado de publicación de un manga en la API.
enum MangaStatus: String, Codable, CaseIterable {
    case discontinued = "discontinued"
    case onHiatus = "on_hiatus"
    case publishing = "currently_publishing"
    case finished = "finished"
    case none = "none"
    
    /// Nombre legible para mostrar en la UI.
    var displayName: String {
        switch self {
        case .discontinued: return "Discontinued"
        case .onHiatus: return "On Hiatus"
        case .publishing: return "Publishing"
        case .finished: return "Finished"
        case .none: return "Unknown"
        }
    }
}

/// Rol de un autor en la creación de un manga.
enum AuthorRole: String, Codable, CaseIterable {
    case art = "Art"
    case storyAndArt = "Story & Art"
    case story = "Story"
    case none = "None"
    
    /// Nombre legible para mostrar en la UI.
    var displayName: String { rawValue }
}

// MARK: - Response Models / Modelos de Respuesta

/// Respuesta paginada de la API para listados de mangas.
struct MangaListResponse: Codable {
    /// Lista de mangas en formato DTO.
    let items: [MangaDTO]
    /// Metadatos de paginación de la respuesta.
    let metadata: MetadataDTO
}

/// Metadatos de paginación tal como los devuelve la API.
struct MetadataDTO: Codable {
    /// Total de resultados disponibles.
    let total: Int
    /// Página actual devuelta.
    let page: Int
    /// Número de items por página.
    let per: Int
}
    
// MARK: - Supporting DTOs / DTOs de Soporte

/// DTO de género tal como lo devuelve la API.
struct GenreDTO: Codable, Identifiable {
    /// Identificador único del género.
    let id: String
    /// Nombre del género en texto plano.
    let genre: String
    
    /// Convierte el género a su representación como enum ``Genre``.
    var asEnum: Genre? { Genre(rawValue: genre) }
}

/// DTO de temática tal como lo devuelve la API.
struct ThemeDTO: Codable, Identifiable {
    /// Identificador único de la temática.
    let id: String
    /// Nombre de la temática en texto plano.
    let theme: String
    
    /// Convierte la temática a su representación como enum ``Theme``.
    var asEnum: Theme? { Theme(rawValue: theme) }
}

/// DTO de demografía tal como lo devuelve la API.
struct DemographicDTO: Codable, Identifiable {
    /// Identificador único de la demografía.
    let id: String
    /// Nombre de la demografía en texto plano.
    let demographic: String
    
    /// Convierte la demografía a su representación como enum ``Demographic``.
    var asEnum: Demographic? { Demographic(rawValue: demographic) }
}

/// DTO de autor tal como lo devuelve la API.
struct AuthorDTO: Codable, Identifiable {
    /// Identificador único del autor.
    let id: String
    /// Nombre del autor.
    let firstName: String
    /// Apellido del autor.
    let lastName: String
    /// Rol del autor en la obra.
    let role: AuthorRole
    
    /// Nombre completo concatenado (firstName + lastName).
    var fullName: String { "\(firstName) \(lastName)" }
}

// MARK: - Main Manga DTO / DTO Principal de Manga

/// DTO principal de manga tal como lo devuelve la API.
/// Contiene todos los campos en sus tipos originales (String, Int, etc.)
/// antes de ser transformado al modelo de dominio ``Manga``.
struct MangaDTO: Codable, Identifiable {
    let id: Int
    let title: String
    let titleEnglish: String?
    let titleJapanese: String?
    /// URL de portada como String sin limpiar.
    let mainPicture: String?
    /// Sinopsis con typo original de la API.
    let sypnosis: String?
    let background: String?
    let score: Double
    let status: MangaStatus
    let chapters: Int?
    let volumes: Int?
    /// Fecha de inicio en formato ISO8601 como String.
    let startDate: String?
    /// Fecha de fin en formato ISO8601 como String.
    let endDate: String?
    /// URL de MyAnimeList como String sin limpiar.
    let url: String?
    let genres: [GenreDTO]
    let themes: [ThemeDTO]
    let demographics: [DemographicDTO]
    let authors: [AuthorDTO]
}

// MARK: - DTO to Model Transformations / Transformaciones de DTO a Modelo

extension MangaDTO {
    /// Transforma el DTO al modelo de dominio ``Manga``.
    /// Limpia URLs, convierte fechas y mapea enums.
    var toManga: Manga {
        Manga(
            id: id,
            title: title,
            titleEnglish: titleEnglish,
            titleJapanese: titleJapanese,
            mainPicture: mainPicture.flatMap { URL(string: $0.cleanedURL) },
            synopsis: sypnosis ?? "",
            background: background,
            score: score,
            status: status,
            chapters: chapters,
            volumes: volumes,
            startDate: startDate?.toDate(),
            endDate: endDate?.toDate(),
            url: url.flatMap { URL(string: $0.cleanedURL) },
            genres: genres.compactMap { Genre(rawValue: $0.genre) },
            themes: themes.compactMap { Theme(rawValue: $0.theme) },
            demographics: demographics.compactMap { Demographic(rawValue: $0.demographic) },
            authors: authors.map(\.toAuthor)
        )
    }
}

extension AuthorDTO {
    /// Transforma el DTO al modelo de dominio ``Author``.
    var toAuthor: Author {
        Author(
            id: id,
            fullName: "\(firstName) \(lastName)",
            role: role
        )
    }
}

extension MetadataDTO {
    /// Transforma el DTO al modelo de dominio ``PaginationMetadata``.
    var toPaginationMetadata: PaginationMetadata {
        PaginationMetadata(
            total: total,
            currentPage: page,
            itemsPerPage: per
        )
    }
}

extension MangaListResponse {
    /// Transforma la respuesta completa al resultado de dominio ``MangaListResult``.
    var toMangaListResult: MangaListResult {
        MangaListResult(
            mangas: items.map(\.toManga),
            metadata: metadata.toPaginationMetadata
        )
    }
}

// MARK: - Helper Extensions / Extensiones de Ayuda

extension String {
    /// Elimina backslashes y comillas de URLs devueltas por la API.
    var cleanedURL: String {
        self.replacingOccurrences(of: "\\", with: "")
            .replacingOccurrences(of: "\"", with: "")
    }
    
    /// Convierte un String en formato ISO8601 a `Date`.
    /// - Returns: `Date` si el formato es válido, `nil` en caso contrario.
    func toDate() -> Date? {
        ISO8601DateFormatter().date(from: self)
    }
}
