//
//  URLRequest.swift
//  EmpleadosAPI
//
//  Created by Sergio García on 19/11/25.
//

// MARK: Para formular la petición a la API, con algunos requisitos a cumplir.

import Foundation

// TODO: Revisar clase 28, 0:25:00 -> 0:45:00
extension URLRequest {
    static func get(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.timeoutInterval = 60 // Por defecto son 10 minutos, 10*60 = 600.
        
        request.setValue("application/json", forHTTPHeaderField: "Accept") // Propago en la llamada que ACEPTO valores JSON, por lo tanto obtener valores JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")         // Para fijar que en las entradas/salidas trabajaré en UTF8.
                                                                                                        //request.setValue("bearer <token>", forHTTPHeaderField: "Authorization")
                                                                                                        //request.setValue("xapptesti", forHTTPHeaderField: <#T##String#>)
        return request
    } 
}
