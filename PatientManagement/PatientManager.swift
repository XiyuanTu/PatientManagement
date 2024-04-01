//
//  PatientManager.swift
//  PatientManagement
//
//  Created by xiyuan tu on 4/1/24.
//

import Foundation

struct PatientManager {
    private var patients = [String: Patient]() // Dict to hold patients by their ID
    private var exams = [String: String]() // Dict to hold patient IDs by exam ID
    
    // Process instructions
    mutating func process(_ instructions: [String]) -> String {
        // Reset data
        patients = [String: Patient]()
        exams = [String: String]()
        
        instructions.forEach { instruction in
            let instructionArr = instruction.split(separator: " ", maxSplits: 3).map{String($0)}
            let category = instructionArr[1]
            switch category {
            case Category.PATIENT.rawValue:
                processPatientData(by: instructionArr)
            case Category.EXAM.rawValue:
                processExamData(by: instructionArr)
            default:
                return
            }
        }
        
        return generateSummary()
    }
    
    // Print out a summary of the patients
    private func generateSummary() -> String {
        return ""
    }
    
    // Process patient related instructions
    private mutating func processPatientData(by instruction: [String]) {
        let operation = instruction[0]
        let id = instruction[2]
        switch operation {
        case Operation.ADD.rawValue:
            let name = instruction[3]
            addPatient(id, name)
        case Operation.DEL.rawValue:
            deletePatient(id)
        default:
            return
        }
    }
    
    // Process exam related instructions
    private mutating func processExamData(by instruction: [String]) {
        let operation = instruction[0]
        
        switch operation {
        case Operation.ADD.rawValue:
            let patientId = instruction[2]
            let examId = instruction[3]
            addExam(patientId, examId)
        case Operation.DEL.rawValue:
            let examId = instruction[2]
            deleteExam(examId)
        default:
            return
        }
    }
    
    // Add a patient
    private mutating func addPatient(_ id: String, _ name: String) {
    }
    
    // Add an exam
    private mutating func addExam(_ patientId: String, _ examId: String) {
    }
    
    // Delete a patient
    private mutating func deletePatient(_ id: String) {
    }
    
    // Delete an exam
    private mutating func deleteExam(_ examId: String) {
    }
}
