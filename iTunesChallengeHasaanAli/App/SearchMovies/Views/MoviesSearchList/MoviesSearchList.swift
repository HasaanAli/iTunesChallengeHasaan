//
//  MoviesSearchList.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 11/03/2025.
//

import SwiftUI

/// View with a searchable list of iTunes movies. 
struct MoviesSearchList: View {
    @StateObject private var vm: MoviesSearchListViewModel = MoviesSearchListViewModel()
    @State private var showAsGrid = true

    private let defaultForegroundStyle = Color.purple

    var body: some View {
        VStack(spacing: 2) {
            LastVisitedView()
            Spacer()
            switch vm.searchState {
            case .startSearch:
                startSearchView
            case .searching:
                ProgressView("Searching...")
                    .foregroundStyle(defaultForegroundStyle)
            case .noResults:
                noResultsView
            case .showResults:
                if showAsGrid {
                    // use grid
                    gridView
                } else {
                    // use list
                    listView
                }
            }
            Spacer()
            listOrGridSwitchButtons
                .padding(3)
        }
        .scrollDismissesKeyboard(.immediately)
        .searchable(text: $vm.searchString, placement: .navigationBarDrawer(displayMode: .always), prompt: "Enter text to search")
        .navigationTitle("Search Movies")
        .navigationBarTitleDisplayMode(.inline)

    }

    var noResultsView: some View {
        middleInfoView(systemIconName: "multiply.square", infoMessage: "No results")
    }

    var startSearchView: some View {
        middleInfoView(systemIconName: "film", infoMessage: "Start searching to see results")
    }

    func middleInfoView(systemIconName: String, infoMessage: String) -> some View {
        VStack {
            Spacer()

            Image(systemName: systemIconName)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundStyle(defaultForegroundStyle)

            Text(infoMessage)

            Spacer()
        }
    }

    var listOrGridSwitchButtons: some View {
        HStack {
            Button("Show as \(showAsGrid ? "List" : "Grid")") {
                showAsGrid.toggle()
            }
        }
    }

    var listView: some View {
        List(vm.movies) { movie in
            NavigationLink {
                MovieDetailView(movie: movie)
            } label: {
                listItemView(movie: movie)
            }
        }
    }

    func listItemView(movie: Movie) -> some View {
        // list item view
        HStack {
            // icon - text <-> heart button
            MovieImageView(imageUrl: movie.localArtURL)
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
                .frame(maxWidth: 50, maxHeight: 100)
                .foregroundStyle(defaultForegroundStyle)

            VStack(alignment: .leading) {
                Text(movie.name)
                    .fontWeight(.semibold)

                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(movie.genre)
                        Text("\(movie.priceUSD, specifier: "%.2f") $")
                    }
                    Spacer()
                    // spacer is needed to fully expand the listItemView so that overlay of favorite button
                    // is at correct bottom right
                }
            }
            .lineLimit(1)
        }
        .overlay(alignment: .bottomTrailing) {
            MovieFavoriteButton(isFavorite: movie.isFavorite) {
                vm.tappedFavorite(movie: movie)
            }
            .padding()
        }
    }

    @ViewBuilder
    var gridView: some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(vm.movies) { movie in
                    NavigationLink {
                        MovieDetailView(movie: movie)
                    } label: {
                        gridItemView(movie: movie)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }

    func gridItemView(movie: Movie) -> some View {
        // grid item view
        VStack {
            // icon
            // name
            // price - heart
            // genre - button
            MovieImageView(imageUrl: movie.localArtURL)
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 100, maxHeight: 200) // limit frame for iPad to not go beyond this size.
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 5, height: 5)))
                .foregroundStyle(defaultForegroundStyle)

            Text(movie.name).fontWeight(.semibold)
                .foregroundStyle(Color.black)

            HStack {
                VStack(alignment: .leading) {
                    Text(movie.genre)
                    Text("\(movie.priceUSD, specifier: "%.2f") $")
                }
                .foregroundStyle(Color.black)
                Spacer()
                // spacer is needed to fully expand the listItemView so that overlay of favorite button
                // is at correct bottom right
            }
        }
        .lineLimit(1)
        .overlay(alignment: .bottomTrailing) {
            MovieFavoriteButton(isFavorite: movie.isFavorite) {
                vm.tappedFavorite(movie: movie)
            }
            .padding()
        }
    }
}

#Preview {
    MoviesSearchList()
}
