//
//  ReadingStatus.swift
//  Tankodex
//
//  Created by Sergio García on 23/2/26.
//

import Foundation

enum ReadingStatus: String, Codable, CaseIterable {
    case wishlist = "Wishlist"
    case reading = "Reading"
    case collected = "Collected"
    case completed = "Completed"
    
    var icon: String {
        switch self {
        case .wishlist:   return "heart.circle"
        case .reading:    return "book"
        case .collected:  return "books.vertical.fill"
        case .completed:  return "checkmark.seal.fill"
        }
    }
}
