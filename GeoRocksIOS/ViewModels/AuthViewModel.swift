//
 //  AuthViewModel.swift
 //  GeoRocksIOS
 //
 //  Created by Carlos Ignacio Padilla Herrera on 12/12/24.
 //
 //  Description:
 //  The AuthViewModel manages user authentication state and related actions using custom JWT on the FastAPI backend.
 //
 
 import SwiftUI
 
 class AuthViewModel: ObservableObject {
     // A published property to track the user's login status
     @Published var isLoggedIn = false
     
     // Published properties for error and success messages
     @Published var errorMessage: String?
     @Published var successMessage: String?
     
     // Dynamic profile user email
     @Published var userEmail: String? = nil
     
     init() {
         // Check if a user has a stored token and verify it
         if NetworkingService.shared.getToken() != nil {
             self.isLoggedIn = true
             verifyTokenAndLogin()
         } else {
             self.isLoggedIn = false
         }
     }
     
     // MARK: - Verify Stored Token
     func verifyTokenAndLogin() {
         guard let token = NetworkingService.shared.getToken() else {
             self.isLoggedIn = false
             return
         }
         
         guard let url = URL(string: "http://192.168.1.64:8003/auth/me") else {
             self.isLoggedIn = false
             return
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         
         let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
             DispatchQueue.main.async {
                 if error != nil {
                     NetworkingService.shared.clearToken()
                     self?.userEmail = nil
                     self?.isLoggedIn = false
                     return
                 }
                 
                 if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                     self?.isLoggedIn = true
                     if let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                         let email = json["email"] as? String ?? json["username"] as? String ?? "admin@unam.mx"
                         self?.userEmail = email
                     }
                 } else {
                     NetworkingService.shared.clearToken()
                     self?.userEmail = nil
                     self?.isLoggedIn = false
                 }
             }
         }
         task.resume()
     }
     
     // MARK: - Sign In with Email/Password
     func signIn(email: String, password: String) {
         guard let url = URL(string: "http://192.168.1.64:8003/auth/token") else {
             self.errorMessage = "URL de servidor inválida."
             return
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
         
         let bodyString = "username=\(email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&password=\(password.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
         request.httpBody = bodyString.data(using: .utf8)
         
         let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
             DispatchQueue.main.async {
                 if let error = error {
                     self?.errorMessage = error.localizedDescription
                     return
                 }
                 
                 guard let data = data else {
                     self?.errorMessage = "No se recibieron datos del servidor backend."
                     return
                 }
                 
                 if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                     if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let detail = errorJson["detail"] as? String {
                         self?.errorMessage = detail
                     } else {
                         self?.errorMessage = "Credenciales incorrectas o error en el servidor (\(httpResponse.statusCode))."
                     }
                     return
                 }
                 
                 do {
                     if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let token = json["access_token"] as? String {
                         NetworkingService.shared.saveToken(token)
                         self?.isLoggedIn = true
                         self?.errorMessage = nil
                     } else {
                         self?.errorMessage = "Respuesta de autenticación inválida del servidor."
                     }
                 } catch {
                     self?.errorMessage = "Error al procesar la respuesta del servidor: \(error.localizedDescription)"
                 }
             }
         }
         task.resume()
     }
     
     // MARK: - Register (Create Account)
     func register(email: String, password: String) {
         guard let url = URL(string: "http://192.168.1.64:8003/auth/signup") else {
             self.errorMessage = "URL de registro inválida."
             return
         }
         
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         
         let body: [String: Any] = [
             "email": email,
             "password": password,
             "username": email
         ]
         
         guard let httpBody = try? JSONSerialization.data(withJSONObject: body) else {
             self.errorMessage = "Error al construir la petición de registro."
             return
         }
         request.httpBody = httpBody
         
         let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
             DispatchQueue.main.async {
                 if let error = error {
                     self?.errorMessage = error.localizedDescription
                     return
                 }
                 
                 guard let data = data else {
                     self?.errorMessage = "No se recibieron datos de confirmación del servidor."
                     return
                 }
                 
                 if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                     if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                        let detail = errorJson["detail"] as? String {
                         self?.errorMessage = detail
                     } else {
                         self?.errorMessage = "Error al registrar la cuenta de administrador (\(httpResponse.statusCode))."
                     }
                     return
                 }
                 
                 // Register success! Log in automatically
                 self?.signIn(email: email, password: password)
                 self?.successMessage = "¡Cuenta creada exitosamente!"
             }
         }
         task.resume()
     }
     
     // MARK: - Reset Password
     func resetPassword(email: String) {
         self.successMessage = "Por favor, contacte al administrador del sistema en la UNAM para restablecer la contraseña del usuario \(email)."
     }
     
     // MARK: - Sign Out
     func signOut() {
         NetworkingService.shared.clearToken()
         self.userEmail = nil
         self.isLoggedIn = false
     }
     
     // MARK: - Clear Messages
     func clearMessages() {
         errorMessage = nil
         successMessage = nil
     }
     
     /// Checks the authentication status and updates the loading state accordingly.
     /// - Parameter completion: A closure that returns a boolean indicating authentication success.
     func checkAuthenticationStatus(completion: @escaping (Bool) -> Void) {
         if NetworkingService.shared.getToken() != nil {
             completion(true)
         } else {
             completion(false)
         }
     }
 }
