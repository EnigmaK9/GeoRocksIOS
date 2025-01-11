//
//  AppearanceSettingsViewModel.swift
//  GeoRocksIOS
//
//  Created by Carlos Ignacio Padilla Herrera on 12/12/24.
//
//  Description:
//  ViewModel para gestionar la configuración de apariencia de la aplicación.
//

import Foundation
import SwiftUI

class AppearanceSettingsViewModel: ObservableObject {
    // Uso de @AppStorage para persistir preferencias de tema
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("fontSize") var fontSize: Double = 16.0
    @AppStorage("highContrast") var highContrast: Bool = false
    
    // Opciones de tamaño de fuente
    let fontSizes: [Double] = [14, 16, 18, 20, 22]
}
