//
//  Page.swift
//  BucketList
//
//  Created by Fernando Callejas on 12/09/24.
//

import Foundation

struct Page: Codable {
    let pageid: Int
    let ns: Int
    let title: String
    let terms: [String: [String]]?
}
