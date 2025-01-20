
// GraphsView.swift
// GeoRocksIOS
// Updated by Assistant on 01/01/2025
// -----------------------------------------------------------
// Description:
// This view displays graphs about the rocks data fetched from
// the backend. It utilizes SwiftUI Charts to visualize
// data such as the distribution of rock types, colors,
// magnetic properties, health risks, and hardness distribution.
// It includes different chart types like Bar Charts, Pie Charts,
// and Line Charts.
// -----------------------------------------------------------

import SwiftUI
import Charts

struct GraphsView: View {
    @EnvironmentObject var rocksViewModel: RocksViewModel

    // Compute the distribution of rock types
    var rockTypeDistribution: [String: Int] {
        var counts = [String: Int]()
        for rock in rocksViewModel.rocks {
            let type = rock.aMemberOf ?? "Unknown"
            counts[type, default: 0] += 1
        }
        return counts
    }

    // Compute the distribution of rock colors
    var colorDistribution: [String: Int] {
        var counts = [String: Int]()
        for rock in rocksViewModel.rocks {
            let colors = rock.color?.components(separatedBy: ",") ?? ["Unknown"]
            for color in colors {
                let trimmedColor = color.trimmingCharacters(in: .whitespacesAndNewlines)
                counts[trimmedColor, default: 0] += 1
            }
        }
        return counts
    }

    // Compute the magnetic property distribution
    var magneticDistribution: [String: Int] {
        var counts = ["Magnetic": 0, "Non-Magnetic": 0]
        for rock in rocksViewModel.rocks {
            let isMagnetic = rock.magnetic ?? false
            if isMagnetic {
                counts["Magnetic", default: 0] += 1
            } else {
                counts["Non-Magnetic", default: 0] += 1
            }
        }
        return counts
    }

    // Compute the health risks distribution
    var healthRiskDistribution: [String: Int] {
        var counts = [String: Int]()
        for rock in rocksViewModel.rocks {
            let risk = rock.healthRisks ?? "None"
            counts[risk, default: 0] += 1
        }
        return counts
    }

    // Compute the hardness distribution
    var hardnessDistribution: [Int: Int] {
        var counts = [Int: Int]()
        for rock in rocksViewModel.rocks {
            if let hardness = rock.hardness {
                counts[hardness, default: 0] += 1
            }
        }
        return counts
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Bar Chart: Distribution of Rock Types
                    if !rockTypeDistribution.isEmpty {
                        Text("Distribution of Rock Types")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)

                        if #available(iOS 16.0, *) {
                            Chart {
                                ForEach(rockTypeDistribution.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                    BarMark(
                                        x: .value("Type", key),
                                        y: .value("Count", value)
                                    )
                                    .foregroundStyle(Color.blue)
                                }
                            }
                            .chartXAxisLabel("Type")
                            .chartYAxisLabel("Count")
                            .frame(height: 300)
                            .padding()
                        }
                    }

                    // Pie Chart: Distribution of Rock Colors
                    if !colorDistribution.isEmpty {
                        Text("Distribution of Rock Colors")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)

                        if #available(iOS 16.0, *) {
                            Chart {
                                ForEach(colorDistribution.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                                    SectorMark(
                                        angle: .value("Count", value),
                                        innerRadius: 50,
                                        angularInset: 1
                                    )
                                    .foregroundStyle(by: .value("Color", key))
                                    .annotation(position: .overlay) {
                                        Text(key)
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .chartLegend(.hidden)
                            .frame(height: 300)
                            .padding()
                        }
                    }

                    // Bar Chart: Magnetic Properties
                    if !magneticDistribution.isEmpty {
                        Text("Magnetic Properties of Rocks")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)

                        if #available(iOS 16.0, *) {
                            Chart {
                                ForEach(magneticDistribution.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                    BarMark(
                                        x: .value("Magnetic", key),
                                        y: .value("Count", value)
                                    )
                                    .foregroundStyle(Color.orange)
                                }
                            }
                            .chartXAxisLabel("Magnetic")
                            .chartYAxisLabel("Count")
                            .frame(height: 300)
                            .padding()
                        }
                    }

                    // Bar Chart: Health Risks
                    if !healthRiskDistribution.isEmpty {
                        Text("Health Risks Associated with Rocks")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)

                        if #available(iOS 16.0, *) {
                            Chart {
                                ForEach(healthRiskDistribution.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                    BarMark(
                                        x: .value("Health Risk", key),
                                        y: .value("Count", value)
                                    )
                                    .foregroundStyle(Color.red)
                                }
                            }
                            .chartXAxisLabel("Health Risk")
                            .chartYAxisLabel("Count")
                            .frame(height: 300)
                            .padding()
                        }
                    }

                    // Line Chart: Hardness Distribution
                    if !hardnessDistribution.isEmpty {
                        Text("Hardness Distribution")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)

                        if #available(iOS 16.0, *) {
                            Chart {
                                ForEach(hardnessDistribution.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                                    LineMark(
                                        x: .value("Hardness", key),
                                        y: .value("Count", value)
                                    )
                                    .foregroundStyle(Color.purple)
                                }
                            }
                            .chartXAxisLabel("Hardness")
                            .chartYAxisLabel("Count")
                            .frame(height: 300)
                            .padding()
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Graphs")
            .onAppear {
                if rocksViewModel.rocks.isEmpty {
                    rocksViewModel.fetchRocks()
                }
            }
        }
    }
}
