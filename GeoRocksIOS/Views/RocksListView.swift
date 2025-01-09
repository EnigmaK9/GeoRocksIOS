//
 //  RocksListView.swift
 //  GeoRocksIOS
 //
 //  Created by Carlos Padilla on 12/12/2024.
 //
 //  Description:
 //  The RocksListView displays a list of rocks fetched from the backend.
 //  Sorting, search, pull-to-refresh, and favorites functionalities have been added to enhance user experience.
 //

import SwiftUI

struct RocksListView: View {
    @StateObject var rocksViewModel = RocksViewModel()
    @State private var searchText: String = "" // State variable for the search text
    @State private var sortOption: SortOption = .ascending // State variable for the selected sort option
    
    // Enum to define sorting options
    enum SortOption: String, CaseIterable, Identifiable {
        case ascending = "A-Z"
        case descending = "Z-A"
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        VStack {
            // Loading state: shows a spinner while data is fetched
            if rocksViewModel.isLoading {
                ProgressView("Loading Rocks...")
                    .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                    .scaleEffect(1.5)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                    .shadow(radius: 5)
            }
            // Error state: displays an error message if fetching data fails
            else if let errorMessage = rocksViewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                    .shadow(radius: 5)
            }
            // Success state: displays a searchable, sortable, and favoritable list of rocks
            else {
                List {
                    // Search bar is added to the list header
                    Section(header: SearchBar(text: $searchText)) {
                        // Sorting picker is added above the list items
                        Picker("Sort By", selection: $sortOption) {
                            ForEach(SortOption.allCases) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.vertical, 5)
                        .onChange(of: sortOption) { _ in
                            rocksViewModel.sortRocks(option: sortOption)
                        }
                        
                        // Rocks are filtered based on the search text and sorted accordingly
                        ForEach(rocksViewModel.filteredAndSortedRocks(searchText: searchText)) { rock in
                            NavigationLink(destination: RockDetailView(rockId: rock.id)) {
                                HStack(spacing: 12) {
                                    // Thumbnail image for the rock
                                    if let thumbnail = rock.thumbnail, let url = URL(string: thumbnail) {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .empty:
                                                Color.gray
                                                    .frame(width: 50, height: 50)
                                                    .overlay(
                                                        ProgressView()
                                                            .progressViewStyle(CircularProgressViewStyle(tint: Color("ButtonDefault")))
                                                    )
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 50, height: 50)
                                                    .clipped()
                                            case .failure:
                                                Color.red
                                                    .frame(width: 50, height: 50)
                                                    .overlay(
                                                        Image(systemName: "photo")
                                                            .foregroundColor(.white)
                                                    )
                                            @unknown default:
                                                Color.gray
                                                    .frame(width: 50, height: 50)
                                            }
                                        }
                                        .cornerRadius(8)
                                        .shadow(radius: 3)
                                    } else {
                                        // Placeholder for missing image
                                        Color.gray
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                            .shadow(radius: 3)
                                    }
                                    
                                    // Rock title with improved typography
                                    Text(rock.title)
                                        .font(.headline)
                                        .foregroundColor(Color("DefaultTextColor"))
                                        .lineLimit(1)
                                    
                                    Spacer()
                                    
                                    // Favorite button
                                    Button(action: {
                                        rocksViewModel.toggleFavorite(rock: rock)
                                    }) {
                                        Image(systemName: rocksViewModel.isFavorite(rock: rock) ? "heart.fill" : "heart")
                                            .foregroundColor(rocksViewModel.isFavorite(rock: rock) ? .red : .gray)
                                    }
                                    .buttonStyle(BorderlessButtonStyle()) // Ensures the button works inside the list
                                }
                                .padding(.vertical, 6)
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color("BoxBackground")))
                                .shadow(radius: 3)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color("BackgroundColor"))
                // Pull-to-refresh functionality is enabled
                .refreshable {
                    rocksViewModel.fetchRocks()
                }
            }
        }
        .background(Color("BackgroundColor").edgesIgnoringSafeArea(.all))
        .navigationTitle("Rocks List")
        .onAppear {
            // Rocks are fetched when the view appears
            rocksViewModel.fetchRocks()
        }
    }
}

// MARK: - SearchBar View
// A custom search bar is defined for use in the list header
struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = "Search Rocks"
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    // Coordinator is used to handle search bar events
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text)
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
    // Coordinator class to conform to UISearchBarDelegate
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        // Updates the text binding when the search text changes
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        // Dismisses the keyboard when the search button is clicked
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
}

struct RocksListView_Previews: PreviewProvider {
    static var previews: some View {
        RocksListView()
            .environmentObject(AuthViewModel())
    }
}
