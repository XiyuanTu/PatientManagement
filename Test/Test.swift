//
//  Test.swift
//  Test
//
//  Created by xiyuan tu on 4/1/24.
//

import XCTest
@testable import PatientManagement
final class Test: XCTestCase {
    
    var patientManager = PatientManager()
    
    func readFile(filename: String) -> [String]? {
        guard let filePath = Bundle(for: type(of: self)).path(forResource: filename, ofType: "txt") else {
            XCTFail("Failed to read file")
            return nil
        }

        var instructions: [String]
        
        do {
            let content = try String(contentsOfFile: filePath, encoding: .utf8)
            instructions = content.components(separatedBy: .newlines).filter {!$0.isEmpty}
        } catch {
            XCTFail("Failed to read file")
            return nil
        }
        
        return instructions
    }

}
