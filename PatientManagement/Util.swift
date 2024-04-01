//
//  Util.swift
//  PatientManagement
//
//  Created by xiyuan tu on 4/1/24.
//

import Foundation

func readFile(_ fileName: String) throws -> [String] {
    let fileManager = FileManager.default
    let currentDirectoryURL = URL(fileURLWithPath: fileManager.currentDirectoryPath)
    let fileURL = currentDirectoryURL.appendingPathComponent(fileName)
    var instructions: [String] = []
    
    do {
        let content = try String(contentsOf: fileURL, encoding: .utf8)
        
        // filter out empty strings after spliting up
        instructions = content.components(separatedBy: .newlines).filter {!$0.isEmpty}
    } catch let error {
        throw error
    }

    return instructions
}
