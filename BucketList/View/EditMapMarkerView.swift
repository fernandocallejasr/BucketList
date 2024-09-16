//
//  EditMapMarkerView.swift
//  BucketList
//
//  Created by Fernando Callejas on 12/09/24.
//

import SwiftUI

struct EditMapMarkerView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    
    @State private var name: String
    @State private var description: String
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
    var onSave: (Location) -> Void
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color
                    .customColorGhostWhite
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        LazyVStack(alignment: .leading) {
                            Text("Location")
                                .font(.title3)
                        }
                        .padding(.leading, 60)
                        .padding(.bottom, 10)
                        
                        TextField("Place Name", text: $name)
                            .frame(width: 250, height: 30)
                            .padding()
                            .background(.customColorGhostWhite)
                            .clipShape(.rect(cornerRadius: 25, style: .circular))
                            .shadow(color: .black.opacity(0.2), radius: 10)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 30)
                        
                        LazyVStack(alignment: .leading) {
                            Text("Description")
                                .font(.title3)
                        }
                        .padding(.leading, 60)
                        .padding(.bottom, 10)
                        
                        TextEditor(text: $description)
                            .scrollContentBackground(.hidden)
                            .frame(width: 250, height: 150)
                            .padding()
                            .background(.customColorGhostWhite)
                            .clipShape(.rect(cornerRadius: 25, style: .circular))
                            .shadow(color: .black.opacity(0.2), radius: 10)
                            .multilineTextAlignment(.center)
                        
                        LazyVStack(alignment: .leading) {
                            Text("Places of interest close")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        VStack {
                            
                            switch loadingState {
                            case .loaded:
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        ForEach(pages, id: \.pageid) { page in
                                            Text(page.title)
                                                .font(.headline)
                                            + Text(": ") +
                                            Text(page.description)
                                                .italic()
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                                .padding(.top)
                            case .loading:
                                VStack {
                                    Text("Loading...")
                                }
                                .frame(height: 155)
                            case .failed:
                                Text("Please try again later.")
                            }
                            
                        }
                        
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        var newLocation = location
//                        newLocation.id = UUID()
                        newLocation.name = name
                        newLocation.description = description
                        
                        onSave(newLocation)
                        dismiss()
                    }
                    .padding(5)
                    .background(.customColorGhostWhite)
                    .clipShape(.rect(cornerRadius: 25, style: .circular))
                    .shadow(color: .black.opacity(0.2), radius: 10)
                    .tint(.primary)
                }
            }
            .onAppear {
                Task {
                    await fetchNearbyPlaces()
                }
            }
//            .task {
//                await fetchNearbyPlaces()
//            }
        }
    }
    
    func fetchNearbyPlaces() async {
        let longitude = location.longitude
        let latitude = location.latitude
        
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(latitude)%7C\(longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

        
        guard let url = URL(string: urlString) else {
            print("Could not create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        do {
            let (data, _) = try await URLSession.shared.data(for: urlRequest)

            let result = try JSONDecoder().decode(Result.self, from: data)

            pages = result.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
            print("Error retrieving data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    EditMapMarkerView(location: .example) {_ in }
}
