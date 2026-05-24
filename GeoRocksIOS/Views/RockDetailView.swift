// RockDetailView.swift
// GeoRocksIOS
// Redesigned: Carlos Padilla & Antigravity on 24/05/2026
//

import SwiftUI
import AVKit
import MapKit

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(Color("DefaultTextColor"))
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 6)
    }
}

struct PropertyGridCell: View {
    let icon: String
    let title: String
    let value: String
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 32, height: 32)
                .background(iconColor.opacity(0.12))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("DefaultTextColor"))
                    .lineLimit(1)
            }
            Spacer()
        }
        .padding(10)
        .background(Color.white.opacity(0.04))
        .cornerRadius(12)
    }
}

struct PremiumCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("BoxBackground"))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.12), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .padding(.horizontal)
    }
}

struct PlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "circle.grid.cross.fill")
                .font(.system(size: 40))
                .foregroundColor(Color("ButtonDefault").opacity(0.8))
            Text("Espécimen Sin Imagen")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("DefaultTextColor"))
            Text("Muestra física catalogada en el servidor local de la UNAM")
                .font(.caption2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("BoxBackground"))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.12), Color.clear],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
    }
}

struct RockDetailView: View {
    let rockId: String
    
    @StateObject var detailViewModel = RockDetailViewModel()
    
    var body: some View {
        ZStack {
            // Background color for page canvas
            Color("BackgroundColor")
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 20) {
                    if detailViewModel.isLoading {
                        Spacer()
                            .frame(height: 100)
                        ProgressView("Cargando detalles...")
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                            .scaleEffect(1.5)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color("BoxBackground")))
                            .padding(.horizontal)
                        Spacer()
                    } else if let error = detailViewModel.error {
                        Spacer()
                            .frame(height: 100)
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text(error)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color("BoxBackground")))
                        .padding(.horizontal)
                        Spacer()
                    } else if let detail = detailViewModel.rockDetail {
                        
                        // 1. Hero Image / Fallback Placeholder Section
                        if let imageUrl = detail.image, let url = URL(string: imageUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 250)
                                        .background(Color("BoxBackground"))
                                        .cornerRadius(20)
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 250)
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                        .cornerRadius(20)
                                case .failure:
                                    PlaceholderView()
                                @unknown default:
                                    PlaceholderView()
                                }
                            }
                            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                            .padding(.horizontal)
                        } else {
                            PlaceholderView()
                                .padding(.horizontal)
                        }
                        
                        // 2. Title & Dynamic Badges Card
                        PremiumCard {
                            VStack(alignment: .leading, spacing: 10) {
                                Text(detail.title ?? "Detalles del Espécimen")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("DefaultTextColor"))
                                
                                if let localities = detail.localities, let firstLoc = localities.first {
                                    HStack(spacing: 6) {
                                        Image(systemName: "mappin.circle.fill")
                                            .foregroundColor(Color("ButtonDefault"))
                                            .font(.subheadline)
                                        Text(firstLoc)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                }
                                
                                HStack(spacing: 8) {
                                    if detail.cut == true {
                                        Text("Corte Físico")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color("ButtonDefault").opacity(0.15))
                                            .foregroundColor(Color("ButtonDefault"))
                                            .cornerRadius(8)
                                    } else {
                                        Text("Sin Corte")
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.white.opacity(0.05))
                                            .foregroundColor(.gray)
                                            .cornerRadius(8)
                                    }
                                    
                                    if detail.thinSection == true {
                                        Text("Lámina Delgada")
                                            .font(.caption2)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.blue.opacity(0.15))
                                            .foregroundColor(.blue)
                                            .cornerRadius(8)
                                    } else {
                                        Text("Sin Lámina")
                                            .font(.caption2)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background(Color.white.opacity(0.05))
                                            .foregroundColor(.gray)
                                            .cornerRadius(8)
                                    }
                                }
                                .padding(.top, 4)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // 3. Properties 2x3 Grid Dashboard Card
                        PremiumCard {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 8) {
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(Color("ButtonDefault"))
                                    Text("Ficha de Propiedades")
                                        .font(.headline)
                                        .foregroundColor(Color("DefaultTextColor"))
                                }
                                
                                Divider()
                                    .background(Color.white.opacity(0.1))
                                    .padding(.bottom, 4)
                                
                                let columns = [
                                    GridItem(.flexible(), spacing: 12),
                                    GridItem(.flexible(), spacing: 12)
                                ]
                                
                                LazyVGrid(columns: columns, spacing: 12) {
                                    PropertyGridCell(
                                        icon: "cube.fill",
                                        title: "Tipo",
                                        value: detail.aMemberOf ?? "Specimen Sample",
                                        iconColor: Color("ButtonDefault")
                                    )
                                    PropertyGridCell(
                                        icon: "paintpalette.fill",
                                        title: "Color",
                                        value: detail.color ?? "No especificado",
                                        iconColor: .purple
                                    )
                                    PropertyGridCell(
                                        icon: "atom",
                                        title: "Fórmula",
                                        value: detail.formula ?? "No especificada",
                                        iconColor: .green
                                    )
                                    PropertyGridCell(
                                        icon: "hammer.fill",
                                        title: "Dureza",
                                        value: detail.hardness != nil && detail.hardness! > 0 ? "\(detail.hardness!)" : "No especificada",
                                        iconColor: .orange
                                    )
                                    PropertyGridCell(
                                        icon: "bolt.shield.fill",
                                        title: "Magnético",
                                        value: detail.magnetic == true ? "Sí" : "No",
                                        iconColor: .red
                                    )
                                    PropertyGridCell(
                                        icon: "mappin.and.ellipse",
                                        title: "Origen",
                                        value: detail.localities?.first ?? "No especificada",
                                        iconColor: .blue
                                    )
                                }
                            }
                        }
                        
                        // 4. Detailed Description Card
                        if let description = detail.longDesc, !description.isEmpty {
                            PremiumCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "doc.text.fill")
                                            .foregroundColor(Color("ButtonDefault"))
                                        Text("Descripción General")
                                            .font(.headline)
                                            .foregroundColor(Color("DefaultTextColor"))
                                    }
                                    Divider()
                                        .background(Color.white.opacity(0.1))
                                        .padding(.vertical, 4)
                                    
                                    Text(description)
                                        .font(.body)
                                        .foregroundColor(Color("DefaultTextColor").opacity(0.9))
                                        .lineSpacing(5)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                        
                        // 5. Expandable Accordion: Advanced Physical Properties
                        if let physicalProperties = detail.physicalProperties {
                            PremiumCard {
                                DisclosureGroup(
                                    content: {
                                        VStack(spacing: 6) {
                                            Divider()
                                                .background(Color.white.opacity(0.1))
                                                .padding(.vertical, 6)
                                            
                                            InfoRow(title: "Sistema Cristalino", value: physicalProperties.ppCrystalSystem ?? "N/A")
                                            InfoRow(title: "Colores", value: physicalProperties.ppColors?.joined(separator: ", ") ?? "N/A")
                                            InfoRow(title: "Brillo", value: physicalProperties.ppLuster ?? "N/A")
                                            InfoRow(title: "Diafanidad", value: physicalProperties.ppDiaphaneity ?? "N/A")
                                            InfoRow(title: "Raya", value: physicalProperties.ppStreak ?? "N/A")
                                            InfoRow(title: "Tenacidad", value: physicalProperties.ppTenacity ?? "N/A")
                                            InfoRow(title: "Clivaje", value: physicalProperties.ppCleavage ?? "N/A")
                                            InfoRow(title: "Fractura", value: physicalProperties.ppFracture ?? "N/A")
                                            InfoRow(title: "Densidad", value: physicalProperties.ppDensity ?? "N/A")
                                            InfoRow(title: "Dureza (Física)", value: "\(physicalProperties.ppHardness ?? 0)")
                                            InfoRow(title: "Magnético (Físico)", value: physicalProperties.ppMagnetic == true ? "Sí" : "No")
                                        }
                                    },
                                    label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "chart.bar.doc.horizontal.fill")
                                                .foregroundColor(Color("ButtonDefault"))
                                            Text("Propiedades Físicas Avanzadas")
                                                .font(.headline)
                                                .foregroundColor(Color("DefaultTextColor"))
                                        }
                                    }
                                )
                                .accentColor(Color("ButtonDefault"))
                            }
                        }
                        
                        // 6. Expandable Accordion: Advanced Chemical Properties
                        if let chemicalProperties = detail.chemicalProperties {
                            PremiumCard {
                                DisclosureGroup(
                                    content: {
                                        VStack(spacing: 6) {
                                            Divider()
                                                .background(Color.white.opacity(0.1))
                                                .padding(.vertical, 6)
                                            
                                            InfoRow(title: "Clasificación Química", value: chemicalProperties.chemicalClassification ?? "N/A")
                                            InfoRow(title: "Fórmula (Química)", value: chemicalProperties.cpFormula ?? "N/A")
                                            
                                            if let elementsListed = chemicalProperties.cpElementsListed, !elementsListed.isEmpty {
                                                InfoRow(title: "Elementos Incluidos", value: elementsListed.joined(separator: ", "))
                                            } else {
                                                InfoRow(title: "Elementos Incluidos", value: "N/A")
                                            }
                                            
                                            if let commonImpurities = chemicalProperties.cpCommonImpurities, !commonImpurities.isEmpty {
                                                InfoRow(title: "Impurezas Comunes", value: commonImpurities.joined(separator: ", "))
                                            } else {
                                                InfoRow(title: "Impurezas Comunes", value: "N/A")
                                            }
                                        }
                                    },
                                    label: {
                                        HStack(spacing: 8) {
                                            Image(systemName: "testtube.2.fill")
                                                .foregroundColor(Color("ButtonDefault"))
                                            Text("Propiedades Químicas Avanzadas")
                                                .font(.headline)
                                                .foregroundColor(Color("DefaultTextColor"))
                                        }
                                    }
                                )
                                .accentColor(Color("ButtonDefault"))
                            }
                        }
                        
                        // 7. Map Section
                        if let lat = detail.latitude, let lon = detail.longitude {
                            PremiumCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "map.fill")
                                            .foregroundColor(Color("ButtonDefault"))
                                        Text("Ubicación Geográfica")
                                            .font(.headline)
                                            .foregroundColor(Color("DefaultTextColor"))
                                    }
                                    Divider()
                                        .background(Color.white.opacity(0.1))
                                        .padding(.vertical, 4)
                                    
                                    MapView(lat: lat, lon: lon)
                                        .frame(height: 200)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.15), radius: 4)
                                }
                            }
                        }
                        
                        // 8. Health Risks
                        if let healthRisks = detail.healthRisks, !healthRisks.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: 8) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.red)
                                    Text("Riesgos para la Salud")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                }
                                Divider()
                                    .background(Color.red.opacity(0.2))
                                    .padding(.vertical, 4)
                                
                                Text(healthRisks)
                                    .font(.subheadline)
                                    .foregroundColor(.red.opacity(0.9))
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.red.opacity(0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.red.opacity(0.25), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal)
                        }
                        
                        // 9. Additional Gallery Carousel
                        if let additionalImages = detail.images, !additionalImages.isEmpty {
                            PremiumCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "photo.stack.fill")
                                            .foregroundColor(Color("ButtonDefault"))
                                        Text("Galería de Muestras")
                                            .font(.headline)
                                            .foregroundColor(Color("DefaultTextColor"))
                                    }
                                    Divider()
                                        .background(Color.white.opacity(0.1))
                                        .padding(.vertical, 4)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(additionalImages, id: \.self) { imageURL in
                                                if let url = URL(string: imageURL) {
                                                    AsyncImage(url: url) { phase in
                                                        switch phase {
                                                        case .empty:
                                                            ProgressView()
                                                                .frame(width: 140, height: 100)
                                                                .background(Color.white.opacity(0.04))
                                                                .cornerRadius(10)
                                                        case .success(let image):
                                                            image
                                                                .resizable()
                                                                .scaledToFill()
                                                                .frame(width: 140, height: 100)
                                                                .clipped()
                                                                .cornerRadius(10)
                                                        case .failure:
                                                            Image(systemName: "photo")
                                                                .font(.title)
                                                                .foregroundColor(.gray)
                                                                .frame(width: 140, height: 100)
                                                                .background(Color.white.opacity(0.04))
                                                                .cornerRadius(10)
                                                        @unknown default:
                                                            EmptyView()
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        // 10. Video Section
                        if let videoURLString = detail.video, let videoURL = URL(string: videoURLString) {
                            PremiumCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "play.rectangle.fill")
                                            .foregroundColor(Color("ButtonDefault"))
                                        Text("Video Demostrativo")
                                            .font(.headline)
                                            .foregroundColor(Color("DefaultTextColor"))
                                    }
                                    Divider()
                                        .background(Color.white.opacity(0.1))
                                        .padding(.vertical, 4)
                                    
                                    VideoPlayer(player: AVPlayer(url: videoURL))
                                        .frame(height: 200)
                                        .cornerRadius(12)
                                        .shadow(color: Color.black.opacity(0.15), radius: 4)
                                }
                            }
                        }
                        
                        // 11. Frequently Asked Questions
                        if let faqs = detail.frequentlyAskedQuestions, !faqs.isEmpty {
                            PremiumCard {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "questionmark.bubble.fill")
                                            .foregroundColor(Color("ButtonDefault"))
                                        Text("Preguntas Frecuentes")
                                            .font(.headline)
                                            .foregroundColor(Color("DefaultTextColor"))
                                    }
                                    Divider()
                                        .background(Color.white.opacity(0.1))
                                        .padding(.vertical, 4)
                                    
                                    ForEach(faqs, id: \.self) { faq in
                                        Text(faq)
                                            .font(.subheadline)
                                            .foregroundColor(Color("DefaultTextColor").opacity(0.9))
                                            .padding(.bottom, 4)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                            }
                        }
                        
                        // 12. Share Feature Section
                        PremiumCard {
                            ShareRockFeature(
                                rockTitle: detail.title ?? "",
                                rockDetails: detail.longDesc ?? "No details available"
                            )
                        }
                        .padding(.bottom, 30)
                    }
                }
                .padding(.top, 10)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            detailViewModel.fetchRockDetail(rockId: rockId)
        }
        .alert(isPresented: Binding<Bool>(
            get: { self.detailViewModel.error != nil },
            set: { _ in self.detailViewModel.error = nil }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(detailViewModel.error ?? "Ocurrió un error desconocido."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct RockDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RockDetailView(rockId: "1")
            .environmentObject(AuthViewModel())
    }
}
