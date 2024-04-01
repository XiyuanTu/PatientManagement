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
        return generateSummary()
    }
    
    // Print out a summary of the patients
    private func generateSummary() -> String {
        return ""
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
