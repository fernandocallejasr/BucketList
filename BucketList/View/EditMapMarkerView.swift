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
    @State private var loadingState = LoadingState.loaded
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
                
                VStack {
                    LazyVStack(alignment: .leading) {
                        Text("City")
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
                    
                    TextField("Place Description", text: $description)
                        .frame(width: 250, height: 200)
                        .padding()
                        .background(.customColorGhostWhite)
                        .clipShape(.rect(cornerRadius: 25, style: .circular))
                        .shadow(color: .black.opacity(0.2), radius: 10)
                        .multilineTextAlignment(.center)
                    
                    VStack {
                        
                        switch loadingState {
                        case .loaded:
                            ScrollView {
                                VStack {
                                    ForEach(pages, id: \.pageid) { page in
                                        Text(page.title)
                                            .font(.headline)
                                        + Text(": ") +
                                        Text("Page description here")
                                            .italic()
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.top)
                        case .loading:
                            Text("Loading...")
                        case .failed:
                            Text("Please try again later.")
                        }
                        
                    }
                    
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Save") {
                        var newLocation = location
                        newLocation.id = UUID()
                        newLocation.name = name
                        newLocation.description = description
                        
                        onSave(newLocation)
                        dismiss()
                    }
                    .padding(10)
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

            pages = result.query.pages.values.sorted { page1, page2 in
                page1.title < page2.title
            }
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
