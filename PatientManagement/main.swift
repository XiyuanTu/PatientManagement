//
//  main.swift
//  PatientManagement
//
//  Created by xiyuan tu on 4/1/24.
//

import Foundation

let arguments = CommandLine.arguments

// By default, read "instruction.txt"
var fileName = "instruction.txt"

if (arguments.count > 1) {
    fileName = arguments[1]
}

var patientManager = PatientManager(viewContext: PersistenceController.shared.container.viewContext)

do {
    let instructions = try readFile(fileName)
    print(patientManager.process(instructions))
} catch let error {
    print(error.localizedDescription)
}

