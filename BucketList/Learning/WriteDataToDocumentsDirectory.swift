//
//  WriteDataToDocumentsDirectory.swift
//  BucketList
//
//  Created by Fernando Callejas on 09/09/24.
//

import SwiftUI

struct WriteDataToDocumentsDirectory: View {
    var body: some View {
        NavigationStack {
            Button("Read and Write") {
                let data = Data("Test Message".utf8)
                let url = URL.documentsDirectory.appending(path: "message.txt")
                
                do {
                    try data.write(to: url, options: [.atomic, .completeFileProtection])
                    let input = try String(contentsOf: url)
                    print(input)
                } catch {
                    print(error.localizedDescription)
                }
                
                FileManager.writeToAppDocuments(fileName: "MyFile.txt", content: "Hola Fer")
                FileManager.writeToAppDocuments(fileName: "MyFile.txt", content: "Adios Fer")
            }
        }
    }
}

#Preview {
    WriteDataToDocumentsDirectory()
}
