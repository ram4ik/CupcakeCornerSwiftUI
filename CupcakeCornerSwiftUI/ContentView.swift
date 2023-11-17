//
//  ContentView.swift
//  CupcakeCornerSwiftUI
//
//  Created by admin on 11/16/23.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct ContentView: View {
    @State private var results = [Result]()
    @State private var counter = 0
    
    var body: some View {
        NavigationStack {
            List(results, id: \.trackId) { item in
                NavigationLink {
                    VStack(alignment: .leading) {
                        Text(item.trackName)
                            .font(.headline)
                            
                        Text(item.collectionName)
                    }
                } label: {
                    VStack(alignment: .leading) {
                        Text(item.trackName)
                            .font(.headline)
                        
                        Text(item.collectionName)
                    }
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("Taylor Swift Songs")
            .toolbar {
                Button("Tap Count: \(counter)") {
                    counter += 1
                }
                .sensoryFeedback(.increase, trigger: counter)
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResponse.results
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
