//
//  Page.swift
//  BucketList
//
//  Created by Fernando Callejas on 12/09/24.
//

import Foundation

struct Page: Codable, Comparable {
    let pageid: Int
    let ns: Int
    let title: String
    let terms: [String: [String]]?
    
    var description: String {
        terms?["description"]?.first ?? "No additional information"
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
