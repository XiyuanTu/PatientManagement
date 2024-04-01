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
    
    // Test the given test case
    func testCase1() throws {
        guard let instructions = readFile(filename: "case1") else { return }
        let summary = patientManager.process(instructions)
        let expected = """
        Name: JOHN DOE, Id: 123, Exam Count: 0
        Name: JANE CROW, Id: 789, Exam Count: 2
        """
        XCTAssertEqual(summary, expected)
    }
    
    
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
