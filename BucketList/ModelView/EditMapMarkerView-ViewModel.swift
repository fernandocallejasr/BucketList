//
//  EditMapMarkerView-ViewModel.swift
//  BucketList
//
//  Created by Fernando Callejas on 16/09/24.
//

import Foundation

extension EditMapMarkerView {
    
    class ViewModel: ObservableObject {
        @Published var name: String
        @Published var description: String
        @Published var loadingState = LoadingState.loading
        @Published var pages = [Page]()
        
        @Published var location: Location
        
        init(location: Location) {
            self.location = location
            
            name = location.name
            description = location.description
        }
        
        func saveLocation() {
            print("Old Name: \(location.name)")
            print("New Name: \(name)")
            
            var newLocation = location
//            newLocation.id = UUID()
            newLocation.name = name
            newLocation.description = description
            
            location = newLocation
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
    
}
