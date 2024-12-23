import SwiftUI

struct MainRocksView: View {
    @StateObject var rocksViewModel = RocksViewModel()
    
    var body: some View {
        NavigationView {
            List(rocksViewModel.rocks) { rock in
                NavigationLink(destination: RockDetailView(rockId: rock.id)) {
                    HStack {
                        // AsyncImage para la miniatura de la roca
                        AsyncImage(url: URL(string: rock.thumbnail ?? "")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        // Título de la roca
                        Text(rock.title)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Rocas")
        }
        .onAppear {
            rocksViewModel.fetchRocks()
        }
    }
}

struct MainRocksView_Previews: PreviewProvider {
    static var previews: some View {
        MainRocksView()
    }
}
