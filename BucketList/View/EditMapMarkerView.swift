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
        }
    }
}

#Preview {
    EditMapMarkerView(location: .example) {_ in }
}
