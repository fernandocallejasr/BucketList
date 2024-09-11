//
//  FileManagerExtension.swift
//  BucketList
//
//  Created by Fernando Callejas on 09/09/24.
//

import Foundation

extension FileManager {
    static func writeToAppDocuments(fileName: String, content: String) {
        let fileURL = URL.documentsDirectory.appending(path: fileName)
        let data = Data(content.utf8)
        
        do {
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            let input = try String(contentsOf: fileURL)
            print(input)
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
