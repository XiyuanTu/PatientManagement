//
//  main.swift
//  PatientManagement
//
//  Created by xiyuan tu on 4/1/24.
//

import Foundation

var fileName = "instruction.txt"

do {
    let instructions = try readFile(fileName)
    print(instructions)
} catch let error {
    print(error.localizedDescription)
}

