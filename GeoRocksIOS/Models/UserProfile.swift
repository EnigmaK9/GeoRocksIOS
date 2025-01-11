// -----------------------------------------------------------
//  UserProfile.swift
//  GeoRocksIOS
//  Author: Carlos Ignacio Padilla Herrera
//  Created: 12/12/2024
//  Last Updated: 01/01/2025
// -----------------------------------------------------------
// Description:
// This file contains a refined model for user profile data.
// It follows best practices for data handling and includes
// senior-level software engineering comments.
// -----------------------------------------------------------

import Foundation

/// A high-level representation of a user’s profile within GeoRocksIOS.
/// It stores essential personal data such as username, email, optional
/// profile pictures, and contact details. The model is designed for
/// easy extension and maintenance.
struct UserProfile: Codable {
    
    /// A unique username that identifies the user within the GeoRocksIOS app.
    let username: String
    
    /// The email address used for authentication and communication.
    let email: String
    
    /// An optional string containing a URL to the user's profile picture.
    /// If provided, it is intended to point to a secure, accessible location.
    let profilePictureURL: String?
    
    /// An optional contact number that can be used for account recovery or
    /// additional user verification processes.
    let phoneNumber: String?
    
    // MARK: - Initializer
    
    /// A designated initializer that sets up the user’s profile.
    /// - Parameters:
    ///   - username: The user’s chosen identifier.
    ///   - email: The user’s valid email address.
    ///   - profilePictureURL: An optional URL referencing the user’s profile image.
    ///   - phoneNumber: An optional contact number for the user.
    ///
    /// This initializer can be expanded as more fields are required by the app.
    init(username: String,
         email: String,
         profilePictureURL: String? = nil,
         phoneNumber: String? = nil) {
        self.username = username
        self.email = email
        self.profilePictureURL = profilePictureURL
        self.phoneNumber = phoneNumber
    }
    
    // MARK: - Future Enhancements
    
    /// Additional attributes and associated properties can be added here in the future,
    /// such as address details, social media handles, or preference flags. Each new field
    /// should be carefully integrated to maintain backward compatibility for existing users.
}
