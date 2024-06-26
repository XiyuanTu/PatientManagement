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
    
    // Get a summary of the patients
    private func generateSummary() -> String {
        var summarys: [String] = []
        for patient in patients.values.sorted(by: {$0.id < $1.id}) {
            summarys.append(patient.summary)
        }
        return summarys.joined(separator: "\n")
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
        // Check if patient doesn't exist
        guard patients[id] == nil else { return }
        patients[id] = Patient(id: id, name: name)
    }
    
    // Add an exam
    private mutating func addExam(_ patientId: String, _ examId: String) {
        // Check if patient exists and exam doesn't exist
        guard patients[patientId] != nil, exams[examId] == nil else { return }
        
        patients[patientId]!.addExam(examId)
        exams[examId] = patientId
    }
    
    // Delete a patient
    private mutating func deletePatient(_ id: String) {
        // Check if patient exists
        guard patients[id] != nil else {return}
        
        // Delete patient's exams in exam dict
        for examId in patients[id]!.exams {
            exams.removeValue(forKey: examId)
        }
        patients.removeValue(forKey: id)
    }
    
    // Delete an exam
    private mutating func deleteExam(_ examId: String) {
        // Delete exam in exam dict and get owner id
        guard let patientId = exams.removeValue(forKey: examId) else { return }
        
        // Delete exam in patient's exams
        patients[patientId]?.deleteExam(examId)
    }
}
