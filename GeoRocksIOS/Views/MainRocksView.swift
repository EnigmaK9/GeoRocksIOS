import SwiftUI

struct MainRocksView: View {
    @StateObject var rocksViewModel = RocksViewModel()
    
    var body: some View {
        NavigationView {
            List(rocksViewModel.rocks) { rock in
                HStack {
                    // If using iOS 15+ AsyncImage:
                    AsyncImage(url: URL(string: rock.thumbnail ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    Text(rock.title)
                        .font(.headline)
                }
            }
            .navigationTitle("Rocks")
        }
        .onAppear {
            rocksViewModel.fetchRocks()
        }
    }
}
