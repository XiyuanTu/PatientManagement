//
//  Test.swift
//  Test
//
//  Created by xiyuan tu on 4/1/24.
//

import XCTest
import CoreData
@testable import PatientManagement
final class Test: XCTestCase {
    
    var patientManager: PatientManager!
    
    override func setUp() {
      super.setUp()
        patientManager = PatientManager(viewContext: PersistenceController(inMemory: true).container.viewContext)
    }
    
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
    
    // Test edge case: add patient record, existed patient
    func testCase2() throws {
        guard let instructions = readFile(filename: "case2") else { return }
        let summary = patientManager.process(instructions)
        let expected = """
        Name: JOHN DOE, Id: 123, Exam Count: 0
        Name: JOE SCMOE, Id: 321, Exam Count: 0
        """
        XCTAssertEqual(summary, expected)
    }
    
    // Test edge case: add exam record, patient not existed & existed exam
    // Test delete exam, which is not included in the given test case
    func testCase3() throws {
        guard let instructions = readFile(filename: "case3") else { return }
        let summary = patientManager.process(instructions)
        let expected = """
        Name: JOHN DOE, Id: 123, Exam Count: 0
        Name: XIYUAN TU, Id: 234, Exam Count: 1
        """
        XCTAssertEqual(summary, expected)
    }
    
    // Test edge case: delete patient record, patient not existed
    func testCase4() throws {
        guard let instructions = readFile(filename: "case4") else { return }
        let summary = patientManager.process(instructions)
        let expected = """
        Name: JOHN DOE, Id: 123, Exam Count: 0
        """
        XCTAssertEqual(summary, expected)
    }
    
    // Test edge case: delete exam record, exam not existed
    func testCase5() throws {
        guard let instructions = readFile(filename: "case5") else {return}
        let summary = patientManager.process(instructions)
        let expected = """
        Name: JOHN DOE, Id: 123, Exam Count: 1
        """
        XCTAssertEqual(summary, expected)
    }
    
    // Test reading multiple files
    func testMultipleCase1() throws {
        guard let firstInstructions = readFile(filename: "case1") else {return}
        guard let secondInstructions = readFile(filename: "case5") else {return}
        patientManager.process(firstInstructions)
        let summary = patientManager.process(secondInstructions)
        let expected = """
        Name: JOHN DOE, Id: 123, Exam Count: 1
        Name: JANE CROW, Id: 789, Exam Count: 2
        """
        XCTAssertEqual(summary, expected)
    }
    
    // Test reading multiple files
    func testMultipleCase2() throws {
        guard let firstInstructions = readFile(filename: "case2") else {return}
        guard let secondInstructions = readFile(filename: "case3") else {return}
        patientManager.process(firstInstructions)
        let summary = patientManager.process(secondInstructions)
        let expected = """
        Name: JOHN DOE, Id: 123, Exam Count: 0
        Name: XIYUAN TU, Id: 234, Exam Count: 1
        Name: JOE SCMOE, Id: 321, Exam Count: 1
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

public extension NSManagedObject {

    convenience init(usedContext: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: usedContext)!
        self.init(entity: entity, insertInto: usedContext)
    }

}
