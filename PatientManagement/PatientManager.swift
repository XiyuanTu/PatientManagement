//
//  PatientManager.swift
//  PatientManagement
//
//  Created by xiyuan tu on 4/1/24.
//

import Foundation
import CoreData

struct PatientManager {
    var viewContext: NSManagedObjectContext
    
    // Process instructions
    mutating func process(_ instructions: [String]) -> String {
        
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
        
        let patients = fetchPatients()!
        
        return generateSummary(patients)
    }
    
    
    // Get a summary of the patients
    private func generateSummary(_ patients: [Patient]) -> String {
        var summarys: [String] = []
        for patient in patients {
            summarys.append("Name: \(patient.name!), Id: \(patient.id!), Exam Count: \(patient.exams?.count ?? 0)")
        }
        return summarys.joined(separator: "\n")
    }
    
    
    func fetchPatients() -> [Patient]? {
        do {
            let request = Patient.fetchRequest() as NSFetchRequest<Patient>
            let sort = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [sort]
            return try viewContext.fetch(request)
        } catch {
            print("Fail to fetch patients")
        }
        
        return nil
    }
    
    func fetchPatient(_ id: String) -> Patient? {
        do {
            let request = Patient.fetchRequest() as NSFetchRequest<Patient>
            let pred = NSPredicate(format: "id == %@", id)
            request.predicate = pred
            return try viewContext.fetch(request).first
        } catch {
            print("Fail to fetch a patient")
        }
        
        return nil
    }
    
    func fetchExams() -> [Exam]? {
        do {
            return try viewContext.fetch(Exam.fetchRequest())
        } catch {
            print("Fail to fetch exams")
        }
        
        return nil
    }
    
    func fetchExam(_ id: String) -> Exam? {
        do {
            let request = Exam.fetchRequest() as NSFetchRequest<Exam>
            let pred = NSPredicate(format: "id == %@", id)
            request.predicate = pred
            return try viewContext.fetch(request).first
        } catch {
            print("Fail to fetch a exam")
        }
        
        return nil
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
    func addPatient(_ id: String, _ name: String) {
        guard let existed = isExistedPatient(id), !existed else { return }
        
        let patient = Patient(context: viewContext)
        patient.id = id
        patient.name = name
        patient.exams = Set()
        
        do {
            try viewContext.save()
        } catch {
            print("Fail to add a patient")
        }
    }
    
    func isExistedPatient(_ id: String) -> Bool? {
        do {
            let request = Patient.fetchRequest() as NSFetchRequest<Patient>
            let pred = NSPredicate(format: "id == %@", id)
            request.predicate = pred
            return try !viewContext.fetch(request).isEmpty
        } catch {
            print("Fail to check a patient")
        }
        
        return nil
    }
    
    
    // Add an exam
    func addExam(_ patientId: String, _ id: String) {
        guard let existedExam = isExistedExam(id), !existedExam, let patient = fetchPatient(patientId) else { return }
        
        let exam = Exam(context: viewContext)
        exam.id = id
        exam.patientId = patientId
        
        patient.exams?.insert(id)
        
        do {
            try viewContext.save()
        } catch {
            print("Fail to add a exam")
        }
    }
    
    func isExistedExam(_ id: String) -> Bool? {
        do {
            let request = Exam.fetchRequest() as NSFetchRequest<Exam>
            let pred = NSPredicate(format: "id == %@", id)
            request.predicate = pred
            return try !viewContext.fetch(request).isEmpty
        } catch {
            print("Fail to check an exam")
        }
        return nil
    }
    
    // Delete a patient
    private mutating func deletePatient(_ id: String) {
        // Check if patient exists
        guard let patient = fetchPatient(id) else {return}
        
        if let exams = patient.exams {
            for examId in exams {
                if let exam = fetchExam(examId) {
                    viewContext.delete(exam)
                }
            }
        }
        
        viewContext.delete(patient)
        
        do {
            try viewContext.save()
        } catch {
            print("Fail to delete the patient")
        }
    }

    // Delete an exam
    private mutating func deleteExam(_ id: String) {
        // Delete exam in exam dict and get owner id
        guard let exam = fetchExam(id) else {return}
        viewContext.delete(exam)
        // Delete exam in patient's exams
        guard let patient = fetchPatient(exam.patientId!) else {return}
        patient.exams = patient.exams!.filter {$0 != id}
        
        do {
            try viewContext.save()
        } catch {
            print("Fail to delete the exam")
        }
    }
}
