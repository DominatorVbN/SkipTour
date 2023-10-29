//
//  MovieDetailView.swift
//
//
//  Created by Amit Samant on 29/10/23.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    AsyncImage(url: movie.imageURL) { image in
                        image
                            .resizable()
                    } placeholder: {
                    }
                    .frame(width: 200.0, height: 200.0 * 1.5)
                    VStack {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text("Rating:")
                                .font(.subheadline)
                            Text(String(format: "%.2f", movie.rating ?? 0))
                                .font(Font.subheadline)
                        }
                        HStack {
                            #if SKIP
                            Image(systemName: "arrow.forward")
                                .foregroundStyle(.green)
                            #else
                            Image(systemName: "arrowtriangle.up.fill")
                                .foregroundStyle(.green)
                            #endif
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
                Text(movie.overview ?? "")
                    .font(.title3)
                    .padding()
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}
