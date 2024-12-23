import Foundation

class RockDetailViewModel: ObservableObject {
    @Published var rockDetail: RockDetailDto?
    @Published var isLoading: Bool = false
    @Published var error: String?

    func fetchRockDetail(rockId: String) {
        // Asegúrate de usar la URL correcta
        let urlString = "https://private-516480-rock9tastic.apiary-mock.com/rocks/rock_detail/\(rockId)"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.error = "URL inválida: \(urlString)"
            }
            print("URL inválida: \(urlString)")
            return
        }
        
        self.isLoading = true
        self.error = nil
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    self?.error = "Error de red: \(error.localizedDescription)"
                }
                print("Error fetching rock detail: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self?.error = "No se recibieron datos."
                }
                print("No data returned for rock detail.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(RockDetailDto.self, from: data)
                DispatchQueue.main.async {
                    self?.rockDetail = decoded
                }
            } catch {
                DispatchQueue.main.async {
                    self?.error = "Error al decodificar datos: \(error.localizedDescription)"
                }
                print("Error decoding rock detail: \(error.localizedDescription)")
            }
        }.resume()
    }
}
