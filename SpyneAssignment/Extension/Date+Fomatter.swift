//
//
// Date+Fomatter.swift
// SpyneAssignment
//
// Created by Nand on 08/12/24
//
        

import Foundation



extension Date {
    func shortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self) 
    }
}

