//
//  ProfileVM.swift
//  Tankodex
//
//  Created by Sergio García on 26/2/26.
//

import SwiftUI
import PhotosUI

/// ViewModel para la gestión del perfil local del usuario.
/// Persiste nombre y foto de perfil usando `UserDefaults`.
@MainActor
@Observable
final class ProfileVM {
    
    /// Nombre del usuario. Se persiste automáticamente en `UserDefaults` al cambiar.
    var username: String {
        didSet { UserDefaults.standard.set(username, forKey: "username") }
    }
    
    /// Imagen de perfil cargada en memoria.
    var profileImage: UIImage?
    
    /// Indica si el usuario tiene foto de perfil guardada en disco.
    var hasProfilePhoto: Bool {
        didSet { UserDefaults.standard.set(hasProfilePhoto, forKey: "hasProfilePhoto") }
    }
    
    init() {
        username = UserDefaults.standard.string(forKey: "username") ?? ""
        hasProfilePhoto = UserDefaults.standard.bool(forKey: "hasProfilePhoto")
        if hasProfilePhoto { profileImage = Self.loadPhoto() }
    }
    
    /// Carga una foto desde `PhotosPickerItem`, la guarda en disco y actualiza el estado.
    /// - Parameter item: Item seleccionado desde `PhotosPicker`.
    func savePhoto(from item: PhotosPickerItem?) async {
        guard let item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let image = UIImage(data: data) else { return }
        UserDefaults.standard.set(data, forKey: "profilePhoto")
        hasProfilePhoto = true
        profileImage = image
    }
    
    /// Recarga la foto de perfil desde disco.
    func loadPhotoFromDisk() {
        profileImage = Self.loadPhoto()
    }
    
    /// Carga la foto de perfil guardada en `UserDefaults`.
    /// - Returns: `UIImage` si existe, `nil` en caso contrario.
    private static func loadPhoto() -> UIImage? {
        guard let data = UserDefaults.standard.data(forKey: "profilePhoto") else { return nil }
        return UIImage(data: data)
    }
}
