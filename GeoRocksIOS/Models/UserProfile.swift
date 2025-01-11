//
//  UserProfile.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 12/12/24.
//
//  Description:
//  Model representing the user's profile information.
//

import Foundation

struct UserProfile: Codable {
    var username: String
    var email: String
    var profilePictureURL: String?
    var phoneNumber: String?
    // Añade más campos según sea necesario.
}
