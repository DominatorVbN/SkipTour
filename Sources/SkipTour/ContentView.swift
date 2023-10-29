import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MovieListView(type: .discover)
                .tabItem {
                    Image(systemName: "heart")
                    Text("Discover")
                }
            MovieListView(type: .trending)
                .tabItem {
                    Image(systemName: "star")
                    Text("Trending")
                }
        }
    }
}
