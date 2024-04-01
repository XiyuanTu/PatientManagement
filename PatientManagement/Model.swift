//
//  Model.swift
//  PatientManagement
//
//  Created by xiyuan tu on 4/1/24.
//

import Foundation

struct Patient {
    let id: String
    private(set) var name: String
    private(set) var exams: Set<String> = Set()
    var summary: String {
        "Name: \(name), Id: \(id), Exam Count: \(exams.count)"
    }
    
    func containsExam(_ id: String) -> Bool {
        return exams.contains(id)
    }
    
    mutating func addExam(_ id: String) {
        exams.insert(id)
    }
    
    mutating func deleteExam(_ id: String) {
        exams.remove(id)
    }
}
