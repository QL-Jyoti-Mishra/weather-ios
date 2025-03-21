//
//  WikiPediaSearch.swift
//  WeatherApp
//
//  Created by Jyoti on 18/03/25.
//

import Foundation
import Combine
import SwiftUI


struct WikipediaSearchResponse: Codable {
    let query: WikipediaQuery
}

struct WikipediaQuery: Codable {
    let search: [WikipediaArticle]
}

struct WikipediaArticle: Codable, Identifiable {
    var id: Int { pageid }  // Use page ID as unique identifier
    let pageid: Int
    let title: String
    let snippet: String
}


class WikipediaSearchViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published private(set) var results: [WikipediaArticle] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchQuery
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // Wait for user to stop typing
            .removeDuplicates()
            .filter { !$0.isEmpty } // Ignore empty search
            .flatMap { query in
                self.fetchArticles(query: query)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] articles in
                self?.results = articles
            }
            .store(in: &cancellables)
    }

    func fetchArticles(query: String) -> AnyPublisher<[WikipediaArticle], Never> {
        guard let url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&format=json&list=search&srsearch=\(query)") else {
            return Just([]).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WikipediaSearchResponse.self, decoder: JSONDecoder())
            .map { $0.query.search }
            .replaceError(with: []) // Handle errors
            .eraseToAnyPublisher()
    }
}


struct WikipediaSearchView: View {
    @StateObject private var viewModel = WikipediaSearchViewModel()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Wikipedia...", text: $viewModel.searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                List(viewModel.results) { article in
                    VStack(alignment: .leading) {
                        Text(article.title)
                            .font(.headline)
                        Text(article.snippet)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Wikipedia Search")
        }
    }
}


//struct ContentView: View {
//    var body: some View {
//        TabView {
//            WeatherView()
//                .tabItem {
//                    Label("Weather", systemImage: "cloud.sun.fill")
//                }
//            
//            WikipediaSearchView()
//                .tabItem {
//                    Label("Search", systemImage: "magnifyingglass")
//                }
//        }
//    }
//}

