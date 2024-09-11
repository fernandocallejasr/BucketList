//
//  Location.swift
//  BucketList
//
//  Created by Fernando Callejas on 10/09/24.
//

import Foundation

struct Location: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
}
