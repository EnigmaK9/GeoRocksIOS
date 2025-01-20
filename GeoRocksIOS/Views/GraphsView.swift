// GraphsView.swift
// GeoRocksIOS
// -----------------------------------------------------------
// GraphsView.swift
// Author: Carlos Padilla on 01/01/2025
// -----------------------------------------------------------
// Description:
// This view displays graphs about the rocks data fetched from
// the mock backend. It utilizes SwiftUI Charts to visualize
// data such as the distribution of rock hardness, types,
// classifications, and health risks.
// -----------------------------------------------------------

import SwiftUI
import Charts

// Define a data model for hardness distribution
struct HardnessData: Identifiable {
    let id = UUID()
    let hardness: Int
    let count: Int
}

// Define a data model for rock types based on color
struct RockTypeData: Identifiable {
    let id = UUID()
    let type: String
    let count: Int
}

// Define a data model for rock member classifications
struct RockMemberData: Identifiable {
    let id = UUID()
    let member: String
    let count: Int
}

// Define a data model for health risks distribution
struct HealthRiskData: Identifiable {
    let id = UUID()
    let risk: String
    let count: Int
}

struct GraphsView: View {
    @EnvironmentObject var rocksViewModel: RocksViewModel

    // Compute the hardness distribution from the rocks data
    var hardnessDistribution: [HardnessData] {
        let hardnessCounts = rocksViewModel.rocks.reduce(into: [:] as [Int: Int]) { counts, rock in
            if let hardness = rock.hardness {
                counts[hardness, default: 0] += 1
            }
        }
        return hardnessCounts.map { HardnessData(hardness: $0.key, count: $0.value) }
            .sorted { $0.hardness < $1.hardness }
    }

    // Compute rock type distribution (using color as a proxy for type)
    var rockTypeDistribution: [RockTypeData] {
        let typeCounts = rocksViewModel.rocks.reduce(into: [:] as [String: Int]) { counts, rock in
            let type = rock.color ?? "Unknown"
            counts[type, default: 0] += 1
        }
        return typeCounts.map { RockTypeData(type: $0.key, count: $0.value) }
            .sorted { $0.type < $1.type }
    }

    // Compute rock member classification distribution
    var rockMemberDistribution: [RockMemberData] {
        let memberCounts = rocksViewModel.rocks.reduce(into: [:] as [String: Int]) { counts, rock in
            let member = rock.aMemberOf ?? "Unknown" // Placeholder since aMemberOf doesn't exist
            counts[member, default: 0] += 1
        }
        return memberCounts.map { RockMemberData(member: $0.key, count: $0.value) }
            .sorted { $0.member < $1.member }
    }

    // Compute health risks distribution
    var healthRiskDistribution: [HealthRiskData] {
        let riskCounts = rocksViewModel.rocks.reduce(into: [:] as [String: Int]) { counts, rock in
            let risk = rock.healthRisks ?? "None"
            counts[risk, default: 0] += 1
        }
        return riskCounts.map { HealthRiskData(risk: $0.key, count: $0.value) }
            .sorted { $0.risk < $1.risk }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Rock Hardness Distribution")
                        .font(.title)
                        .padding()

                    if #available(iOS 16.0, *) {
                        // Bar chart for hardness distribution
                        Chart(hardnessDistribution) { dataPoint in
                            BarMark(
                                x: .value("Hardness", dataPoint.hardness),
                                y: .value("Count", dataPoint.count)
                            )
                            .foregroundStyle(Color.blue)
                        }
                        .chartXAxisLabel("Hardness")
                        .chartYAxisLabel("Number of Rocks")
                        .frame(height: 300)
                        .padding()
                    } else {
                        Text("Charts are available on iOS 16 and above.")
                            .foregroundColor(.red)
                            .padding()
                    }

                    // Bar chart for rock type distribution
                    Text("Rock Type Distribution")
                        .font(.title)
                        .padding()
                    if #available(iOS 16.0, *) {
                        Chart(rockTypeDistribution) { dataPoint in
                            BarMark(
                                x: .value("Type", dataPoint.type),
                                y: .value("Count", dataPoint.count)
                            )
                            .foregroundStyle(Color.green)
                        }
                        .chartXAxisLabel("Rock Type")
                        .chartYAxisLabel("Count")
                        .frame(height: 300)
                        .padding()
                    }

                    // Bar chart for rock member classification distribution
                    Text("Rock Member Classification Distribution")
                        .font(.title)
                        .padding()
                    if #available(iOS 16.0, *) {
                        Chart(rockMemberDistribution) { dataPoint in
                            BarMark(
                                x: .value("Member", dataPoint.member),
                                y: .value("Count", dataPoint.count)
                            )
                            .foregroundStyle(Color.orange)
                        }
                        .chartXAxisLabel("Rock Member Classification")
                        .chartYAxisLabel("Count")
                        .frame(height: 300)
                        .padding()
                    }

                    // Bar chart for health risks distribution
                    Text("Health Risks Distribution")
                        .font(.title)
                        .padding()
                    if #available(iOS 16.0, *) {
                        Chart(healthRiskDistribution) { dataPoint in
                            BarMark(
                                x: .value("Risk", dataPoint.risk),
                                y: .value("Count", dataPoint.count)
                            )
                            .foregroundStyle(Color.red)
                        }
                        .chartXAxisLabel("Health Risk")
                        .chartYAxisLabel("Count")
                        .frame(height: 300)
                        .padding()
                    }
                }
            }
            .navigationTitle("Graphs")
        }
    }
}

struct GraphsView_Previews: PreviewProvider {
    static var previews: some View {
        GraphsView()
            .environmentObject(RocksViewModel())
    }
}
