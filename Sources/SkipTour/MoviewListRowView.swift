//
//  SwiftUIView.swift
//  
//
//  Created by Amit Samant on 29/10/23.
//

import SwiftUI

struct MoviewListRowView: View {
    let movie: Movie
    var body: some View {
        HStack (alignment: .top) {
            AsyncImage(url: movie.imageURL) { image in
                image
                    .resizable()
            } placeholder: {
                
            }
            .frame(width: 100.0, height: 150.0)
            VStack(alignment: .leading) {
                Text(movie.title ?? "NA")
                    .font(.headline)
                HStack {
                    Text("Rating:")
                        .font(.subheadline)
                    Text(String(format: "%.2f", movie.rating ?? 0))
                        .font(Font.subheadline)
                }
                HStack {
                    Text("Popularity")
                        .font(.subheadline)
                    Text(String(format: "%.2f", movie.popularity ?? 0))
                        .font(Font.subheadline)
                }
                Text(movie.mediaType?.uppercased() ?? "NA")
                    .font(Font.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.all, 5.0)
                    .background(.blue)
            }
        }
        #if SKIP
        .padding()
        #endif
    }
}
