// -----------------------------------------------------------
// GraphsView.swift
// GeoRocksIOS
// Redesigned by Antigravity on 24/05/2026
// -----------------------------------------------------------
// Description:
// A premium, beautifully styled Geology Telemetry and Analytics Dashboard.
// It visualizes rock catalog metrics such as Mohs hardness distribution,
// magnetic resonance ratio, health risks, color composition, and rock types
// using highly polished SwiftUI Charts and summary telemetry cards.
// -----------------------------------------------------------

import SwiftUI
import Charts

struct GraphsView: View {
    @EnvironmentObject var rocksViewModel: RocksViewModel

    // -----------------------------------------------------------
    // Calculated Properties & Telemetry Data
    // -----------------------------------------------------------

    var averageHardness: Double {
        let validHardnesses = rocksViewModel.rocks.compactMap { $0.hardness }
        guard !validHardnesses.isEmpty else { return 0.0 }
        return Double(validHardnesses.reduce(0, +)) / Double(validHardnesses.count)
    }

    var magneticPercentage: Double {
        let total = rocksViewModel.rocks.count
        guard total > 0 else { return 0.0 }
        let magneticCount = rocksViewModel.rocks.filter { $0.magnetic == true }.count
        return (Double(magneticCount) / Double(total)) * 100.0
    }

    var rockTypeDistribution: [String: Int] {
        var counts = [String: Int]()
        for rock in rocksViewModel.rocks {
            let type = rock.aMemberOf ?? "Sin Clasificar"
            counts[type, default: 0] += 1
        }
        return counts
    }

    var colorDistribution: [String: Int] {
        var counts = [String: Int]()
        for rock in rocksViewModel.rocks {
            let colors = rock.color?.components(separatedBy: ",") ?? ["Sin clasificar"]
            for color in colors {
                let trimmedColor = color.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedColor.isEmpty {
                    counts[trimmedColor, default: 0] += 1
                }
            }
        }
        return counts
    }

    var magneticDistribution: [String: Int] {
        var counts = ["Magnético": 0, "No Magnético": 0]
        for rock in rocksViewModel.rocks {
            let isMagnetic = rock.magnetic ?? false
            if isMagnetic {
                counts["Magnético", default: 0] += 1
            } else {
                counts["No Magnético", default: 0] += 1
            }
        }
        return counts
    }

    var healthRiskDistribution: [String: Int] {
        var counts = [String: Int]()
        for rock in rocksViewModel.rocks {
            let risk = rock.healthRisks ?? "Ninguno"
            counts[risk, default: 0] += 1
        }
        return counts
    }

    var hardnessDistribution: [Int: Int] {
        var counts = [Int: Int]()
        for rock in rocksViewModel.rocks {
            if let hardness = rock.hardness {
                counts[hardness, default: 0] += 1
            }
        }
        return counts
    }

    // -----------------------------------------------------------
    // UI Layout
    // -----------------------------------------------------------

    var body: some View {
        NavigationView {
            ZStack {
                // Homogeneous background matching the theme
                Color("BackgroundColor")
                    .edgesIgnoringSafeArea(.all)

                if rocksViewModel.isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                            .scaleEffect(1.5)
                        Text("Analizando catálogo geológico...")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                } else if rocksViewModel.rocks.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "chart.bar.xaxis")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.6))
                        Text("No hay suficientes datos para graficar")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 22) {
                            
                            // Header Banner
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Gabinete Analítico")
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundColor(Color("DefaultTextColor"))
                                
                                Text("Monitoreo y telemetría mineralógica de GeoRocks UNAM.")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            .padding(.top, 16)

                            // Telemetry Stats Row
                            HStack(spacing: 12) {
                                StatCardView(
                                    title: "Muestras",
                                    value: "\(rocksViewModel.rocks.count)",
                                    iconName: "square.stack.3d.up.fill",
                                    iconColor: Color("ButtonDefault")
                                )
                                
                                StatCardView(
                                    title: "Dureza Prom.",
                                    value: String(format: "%.1f", averageHardness),
                                    iconName: "hammer.fill",
                                    iconColor: .purple
                                )
                                
                                StatCardView(
                                    title: "Magnéticas",
                                    value: String(format: "%.0f%%", magneticPercentage),
                                    iconName: "waveform.path.ecg.strong",
                                    iconColor: .blue
                                )
                            }
                            .padding(.horizontal)

                            // Dashboard Grid of Charts
                            VStack(spacing: 20) {
                                
                                // Chart 1: Mohs Hardness Distribution (Area/Line Chart)
                                if !hardnessDistribution.isEmpty {
                                    ChartCardView(
                                        title: "Distribución de Dureza (Mohs)",
                                        subtitle: "Frecuencia de muestras clasificadas del 1 al 10 en la escala de Mohs.",
                                        iconName: "hammer.fill",
                                        iconColor: .purple
                                    ) {
                                        if #available(iOS 16.0, *) {
                                            Chart {
                                                ForEach(hardnessDistribution.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                                    AreaMark(
                                                        x: .value("Dureza", key),
                                                        y: .value("Muestras", value)
                                                    )
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [.purple.opacity(0.3), .purple.opacity(0.0)],
                                                            startPoint: .top,
                                                            endPoint: .bottom
                                                        )
                                                    )
                                                    .interpolationMethod(.catmullRom)
                                                    
                                                    LineMark(
                                                        x: .value("Dureza", key),
                                                        y: .value("Muestras", value)
                                                    )
                                                    .foregroundStyle(Color.purple)
                                                    .lineStyle(StrokeStyle(lineWidth: 3))
                                                    .interpolationMethod(.catmullRom)
                                                    
                                                    PointMark(
                                                        x: .value("Dureza", key),
                                                        y: .value("Muestras", value)
                                                    )
                                                    .foregroundStyle(Color.purple)
                                                }
                                            }
                                            .frame(height: 180)
                                            .chartXScale(domain: 1...10)
                                            .chartXAxis {
                                                AxisMarks(values: Array(1...10))
                                            }
                                        } else {
                                            Text("Función disponible en iOS 16 o superior.")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }

                                // Chart 2: Magnetic resonance (Donut Chart)
                                if !magneticDistribution.isEmpty {
                                    ChartCardView(
                                        title: "Resonancia Magnética",
                                        subtitle: "Proporción de muestras con propiedades ferromagnéticas.",
                                        iconName: "waveform.path.ecg.strong",
                                        iconColor: .blue
                                    ) {
                                        if #available(iOS 16.0, *) {
                                            HStack(spacing: 20) {
                                                Chart {
                                                    ForEach(magneticDistribution.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                                        SectorMark(
                                                            angle: .value("Muestras", value),
                                                            innerRadius: .ratio(0.6),
                                                            angularInset: 2
                                                        )
                                                        .foregroundStyle(key == "Magnético" ? Color.blue : Color.gray.opacity(0.3))
                                                        .cornerRadius(6)
                                                    }
                                                }
                                                .frame(width: 140, height: 140)
                                                
                                                VStack(alignment: .leading, spacing: 10) {
                                                    HStack {
                                                        Circle().fill(Color.blue).frame(width: 10, height: 10)
                                                        Text("Magnético: \(magneticDistribution["Magnético"] ?? 0)")
                                                            .font(.caption)
                                                            .foregroundColor(Color("DefaultTextColor"))
                                                    }
                                                    HStack {
                                                        Circle().fill(Color.gray.opacity(0.3)).frame(width: 10, height: 10)
                                                        Text("No Magnético: \(magneticDistribution["No Magnético"] ?? 0)")
                                                            .font(.caption)
                                                            .foregroundColor(Color("DefaultTextColor"))
                                                    }
                                                }
                                                Spacer()
                                            }
                                        } else {
                                            Text("Función disponible en iOS 16 o superior.")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }

                                // Chart 3: Distribution of Rock Types (Horizontal Bar Chart)
                                if !rockTypeDistribution.isEmpty {
                                    ChartCardView(
                                        title: "Clasificación de Rocas",
                                        subtitle: "Distribución según su origen geológico primario.",
                                        iconName: "square.stack.3d.up.fill",
                                        iconColor: Color("ButtonDefault")
                                    ) {
                                        if #available(iOS 16.0, *) {
                                            Chart {
                                                ForEach(rockTypeDistribution.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                                                    BarMark(
                                                        x: .value("Muestras", value),
                                                        y: .value("Clase", key)
                                                    )
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [Color("ButtonDefault"), Color("ButtonDefault").opacity(0.6)],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                    .cornerRadius(6)
                                                }
                                            }
                                            .frame(height: 160)
                                        } else {
                                            Text("Función disponible en iOS 16 o superior.")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }

                                // Chart 4: Toxicity & Health Risks (Vertical Bar Chart)
                                if !healthRiskDistribution.isEmpty {
                                    ChartCardView(
                                        title: "Riesgos de Toxicidad",
                                        subtitle: "Identificación de niveles de toxicidad en el catálogo.",
                                        iconName: "exclamationmark.triangle.fill",
                                        iconColor: .orange
                                    ) {
                                        if #available(iOS 16.0, *) {
                                            Chart {
                                                ForEach(healthRiskDistribution.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                                                    BarMark(
                                                        x: .value("Riesgo", key),
                                                        y: .value("Muestras", value)
                                                    )
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [Color.orange, Color.red.opacity(0.8)],
                                                            startPoint: .top,
                                                            endPoint: .bottom
                                                        )
                                                    )
                                                    .cornerRadius(6)
                                                }
                                            }
                                            .frame(height: 180)
                                        } else {
                                            Text("Función disponible en iOS 16 o superior.")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }

                                // Chart 5: Top Colors (Horizontal Bar Chart)
                                if !colorDistribution.isEmpty {
                                    ChartCardView(
                                        title: "Composición Cromática (Top 6)",
                                        subtitle: "Predominancia de tonalidades en las muestras recolectadas.",
                                        iconName: "paintpalette.fill",
                                        iconColor: .pink
                                    ) {
                                        if #available(iOS 16.0, *) {
                                            Chart {
                                                ForEach(colorDistribution.sorted(by: { $0.value > $1.value }).prefix(6), id: \.key) { key, value in
                                                    BarMark(
                                                        x: .value("Muestras", value),
                                                        y: .value("Color", key)
                                                    )
                                                    .foregroundStyle(
                                                        LinearGradient(
                                                            colors: [.pink, .pink.opacity(0.6)],
                                                            startPoint: .leading,
                                                            endPoint: .trailing
                                                        )
                                                    )
                                                    .cornerRadius(4)
                                                }
                                            }
                                            .frame(height: 180)
                                        } else {
                                            Text("Función disponible en iOS 16 o superior.")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }

                            }
                            .padding(.horizontal)
                            .padding(.bottom, 30)

                        }
                    }
                }
            }
            .navigationTitle("Estadísticas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("BackgroundColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear {
                if rocksViewModel.rocks.isEmpty {
                    rocksViewModel.fetchRocks()
                }
            }
        }
    }
}

// -----------------------------------------------------------
// Premium Custom Components for Telemetry Analytics
// -----------------------------------------------------------

struct StatCardView: View {
    let title: String
    let value: String
    let iconName: String
    let iconColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundColor(iconColor)
                .padding(8)
                .background(iconColor.opacity(0.12))
                .clipShape(Circle())
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("DefaultTextColor"))
                .lineLimit(1)
            
            Text(title)
                .font(.caption2)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .padding(.horizontal, 8)
        .background(Color("BoxBackground"))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 3)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
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

struct ChartCardView<Content: View>: View {
    let title: String
    let subtitle: String
    let iconName: String
    let iconColor: Color
    let content: Content
    
    init(title: String, subtitle: String, iconName: String, iconColor: Color, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.iconColor = iconColor
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                Image(systemName: iconName)
                    .font(.title3)
                    .foregroundColor(iconColor)
                    .frame(width: 36, height: 36)
                    .background(iconColor.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color("DefaultTextColor"))
                    
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
                .background(Color.white.opacity(0.08))
            
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

// -----------------------------------------------------------
// Preview
// -----------------------------------------------------------

struct GraphsView_Previews: PreviewProvider {
    static var previews: some View {
        GraphsView()
            .environmentObject(RocksViewModel())
    }
}
