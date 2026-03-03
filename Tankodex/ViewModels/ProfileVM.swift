//
//  ProfileVM.swift
//  Tankodex
//
//  Created by Sergio García on 26/2/26.
//

import SwiftUI
import PhotosUI

/// ViewModel para la gestión del perfil local del usuario.
/// Persiste nombre y icono de perfil usando `UserDefaults`.
@Observable
final class ProfileVM {
    var username: String {
        didSet { UserDefaults.standard.set(username, forKey: "username") }
    }

    var avatar: String {
        didSet { UserDefaults.standard.set(avatar, forKey: "avatar") }
    }

    init() {
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        avatar = UserDefaults.standard.string(forKey: "avatar") ?? "😀"
    }
}
