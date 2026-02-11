//
//  NetworkError.swift
//  myMangas
//
//  Created by Sergio García on 30/12/25.
//


// MARK: Control de Errores

import Foundation

// TODO: Buscar información en el curso sobre -> error vs LocalizedError

enum NetworkError: LocalizedError {
    case general(Error)
    case status(Int)
    case json(Error)
    case dataNoValid
    case nonHTTP
    
    var errorDescription: String? {
        switch self {
        case .general(let error):
            error.localizedDescription
        case .status(let code):
            "HTTP status code: \(code)"
        case .json(let error):
            "JSON error: \(error)"
        case .dataNoValid:
            "Invalid data received from server"
        case .nonHTTP:
            "URLSession did not return a HTTPURLResponse"
        }
    }
}
