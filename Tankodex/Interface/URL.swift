    //
    //  URL.swift
    //  myMangas
    //
    //  Created by Sergio García on 30/12/25.
    //


    // MARK: Creación de URLS a la API de los Endpoints que vayamos a usar.
    // Las creamos cómo extensión de URL.
import Foundation


    // Mientras se debuggea usaría localhost, en la appstore usaría la api online.
    //#if DEBUG
    //let api = URL(string: "https://localhost:8080/api")!
    //#else
    //let api = URL(string: "https://acacademy-employees-api.herokuapp.com/api")!
    //#endif

let api = URL(string: "https://mymanga-acacademy-5607149ebe3d.herokuapp.com")!

extension URL {
    static func getMangas(page: Int = 1, per: Int = 20) -> URL {
        api.appending(path: "/list/bestMangas")
            .appending(queryItems: [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "per", value: "\(per)")
            ])
    }
}

