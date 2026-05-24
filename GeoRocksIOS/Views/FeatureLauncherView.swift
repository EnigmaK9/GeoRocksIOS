// -----------------------------------------------------------
// FeatureLauncherView.swift
// Author: Carlos Padilla on 01/01/2025
// Redesigned by Antigravity on 24/05/2026
// -----------------------------------------------------------
// Description:
// A premium, beautifully designed Geological Laboratory dashboard (Laboratorio UNAM)
// that fits the geological and academic theme of GeoRocks.
// It integrates system features like push notifications, local notifications,
// in-app purchases, visual theme switching, biometric vault, and accessibility.
// -----------------------------------------------------------

import SwiftUI

struct FeatureLauncherView: View {
    // States to track features
    @State private var pushTriggered = false
    @State private var localNotifScheduled = false
    @State private var iapFetched = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Homogeneous background matching the theme
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        
                        // Academic & Branded Header Banner
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Laboratorio UNAM")
                                .font(.system(size: 32, weight: .black, design: .rounded))
                                .foregroundColor(Color("DefaultTextColor"))
                            
                            Text("Instrumentos de campo y servicios avanzados de análisis geológico.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)

                        // Dashboard Grid / Stack of premium cards
                        VStack(spacing: 20) {
                            
                            // Card 1: Geological Alerts (Push & Local)
                            FeatureCardView(
                                iconName: "bell.badge.fill",
                                iconColor: .orange,
                                title: "Alertas y Notificaciones de Campo",
                                description: "Suscríbete a alertas de nuevos descubrimientos geológicos de la UNAM o programa un simulador de exploración de campo."
                            ) {
                                HStack(spacing: 12) {
                                    Button(action: {
                                        PushNotificationManager.shared.requestAuthorization()
                                        pushTriggered = true
                                        alertMessage = "¡Notificaciones de campo autorizadas!"
                                        showAlert = true
                                    }) {
                                        Label("Autorizar", systemImage: "bell.fill")
                                    }
                                    .buttonStyle(LabButtonStyle(backgroundColor: .orange))
                                    
                                    Button(action: {
                                        let manager = LocalNotificationManager()
                                        manager.scheduleNotification(
                                            title: "Exploración de Campo GeoRocks",
                                            body: "¡Un nuevo espécimen mineral ha sido catalogado cerca de tu área!",
                                            timeInterval: 5
                                        )
                                        localNotifScheduled = true
                                        alertMessage = "Alerta programada. Llegará en 5 segundos."
                                        showAlert = true
                                    }) {
                                        Label("Simular Campo", systemImage: "timer")
                                    }
                                    .buttonStyle(LabButtonStyle(backgroundColor: .gray))
                                }
                            }
                            
                            // Card 2: Rare Minerals Vault (IAP)
                            FeatureCardView(
                                iconName: "lock.shield.fill",
                                iconColor: .yellow,
                                title: "Bóveda de Minerales Raros",
                                description: "Desbloquea la base de datos exclusiva de minerales raros, coordenadas geográficas de yacimientos y herramientas avanzadas de simulación."
                            ) {
                                Button(action: {
                                    IAPManager.shared.fetchProducts(productIDs: ["com.yourapp.exampleitem"])
                                    iapFetched = true
                                    alertMessage = "¡Bóveda Premium desbloqueada con éxito!"
                                    showAlert = true
                                }) {
                                    Label("Desbloquear Bóveda", systemImage: "lock.open.fill")
                                }
                                .buttonStyle(LabButtonStyle(backgroundColor: Color("ButtonDefault")))
                            }
                            
                            // Card 3: Biometric Collection Security (FaceID)
                            FeatureCardView(
                                iconName: "faceid",
                                iconColor: .blue,
                                title: "Acceso Geológico Seguro",
                                description: "Protege tu colección privada de especímenes, tus notas científicas de campo y tus descubrimientos con seguridad biométrica."
                            ) {
                                Button(action: {
                                    BiometricAuthManager.shared.authenticateUser { success, errorMessage in
                                        DispatchQueue.main.async {
                                            if success {
                                                alertMessage = "¡Identidad de Geólogo confirmada! Acceso a notas privadas concedido."
                                            } else {
                                                alertMessage = "Autenticación fallida: \(errorMessage ?? "Inténtalo de nuevo")"
                                            }
                                            showAlert = true
                                        }
                                    }
                                }) {
                                    Label("Acceder con FaceID", systemImage: "faceid")
                                }
                                .buttonStyle(LabButtonStyle(backgroundColor: .blue))
                            }
                            
                            // Card 4: Visual Environment Theme (Theme Manager)
                            FeatureCardView(
                                iconName: "paintpalette.fill",
                                iconColor: .purple,
                                title: "Entorno del Laboratorio",
                                description: "Ajusta el tema visual de la aplicación para análisis de alta luminosidad diurna o bajo condiciones de luz tenue."
                            ) {
                                Button(action: {
                                    ThemeManager.shared.toggleTheme()
                                    alertMessage = "¡Modo visual del laboratorio alternado!"
                                    showAlert = true
                                }) {
                                    Label("Alternar Modo", systemImage: "paintbrush")
                                }
                                .buttonStyle(LabButtonStyle(backgroundColor: .purple))
                            }
                            
                            // Card 5: Voice Guide (Accessibility / VoiceOver Champion)
                            FeatureCardView(
                                iconName: "waveform.circle.fill",
                                iconColor: .pink,
                                title: "Guía Geológica Inclusiva",
                                description: "Activa el asistente por voz de la UNAM diseñado para narrar la composición, dureza y detalles de las rocas para geólogos con discapacidad visual."
                            ) {
                                NavigationLink(destination: AccessibilityExampleView()) {
                                    Label("Iniciar Asistente por Voz", systemImage: "accessibility")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 10)
                                        .padding(.horizontal, 16)
                                        .background(
                                            LinearGradient(
                                                colors: [.pink, .pink.opacity(0.8)],
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                        )
                                        .cornerRadius(10)
                                        .shadow(color: Color.pink.opacity(0.2), radius: 4, x: 0, y: 2)
                                }
                            }
                            
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("Laboratorio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("BackgroundColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Laboratorio UNAM"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Entendido"))
                )
            }
        }
    }
}

// -----------------------------------------------------------
// Premium Custom Components for Laboratorio UNAM Dashboard
// -----------------------------------------------------------

struct FeatureCardView<Content: View>: View {
    let iconName: String
    let iconColor: Color
    let title: String
    let description: String
    let content: Content
    
    init(iconName: String, iconColor: Color, title: String, description: String, @ViewBuilder content: () -> Content) {
        self.iconName = iconName
        self.iconColor = iconColor
        self.title = title
        self.description = description
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top, spacing: 16) {
                // Vibrant Branded Icon Container
                Image(systemName: iconName)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        LinearGradient(
                            colors: [iconColor, iconColor.opacity(0.85)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: iconColor.opacity(0.3), radius: 6, x: 0, y: 3)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DefaultTextColor"))
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.08))
            
            // Customized action buttons
            content
        }
        .padding(16)
        .background(Color("BoxBackground"))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    LinearGradient(
                        colors: [Color.white.opacity(0.12), Color.clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
    }
}

struct LabButtonStyle: ButtonStyle {
    let backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background(
                LinearGradient(
                    colors: [backgroundColor, backgroundColor.opacity(0.85)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .shadow(color: backgroundColor.opacity(0.15), radius: 4, x: 0, y: 2)
    }
}

// -----------------------------------------------------------
// Preview
// -----------------------------------------------------------

struct FeatureLauncherView_Previews: PreviewProvider {
    static var previews: some View {
        FeatureLauncherView()
    }
}
