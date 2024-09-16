//
//  EditMapMarkerView.swift
//  BucketList
//
//  Created by Fernando Callejas on 12/09/24.
//

import SwiftUI

struct EditMapMarkerView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var viewModel: ViewModel
    
    var onSave: (Location) -> Void
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = StateObject(wrappedValue: ViewModel(location: location))
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
                        
                        TextField("Place Name", text: $viewModel.name)
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
                        
                        TextEditor(text: $viewModel.description)
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
                            
                            switch viewModel.loadingState {
                            case .loaded:
                                ScrollView {
                                    VStack(alignment: .leading) {
                                        ForEach(viewModel.pages, id: \.pageid) { page in
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
                        viewModel.saveLocation()
                        onSave(viewModel.location)
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
                    await viewModel.fetchNearbyPlaces()
                }
            }
//            .task {
//                await fetchNearbyPlaces()
//            }
        }
    }
}

#Preview {
    EditMapMarkerView(location: .example) {_ in }
}
