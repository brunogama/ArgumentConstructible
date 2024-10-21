//
//  TuplePairGenerator.swift
//  VariadicArgumentConstructable
//
//  Created by Bruno on 20/10/24.
//

import Foundation

protocol RandomValue: Sendable {
    static func generateRandom() -> Self
}

extension String: RandomValue {
    static func generateRandom() -> String {
        let length = Int.random(in: 1...10)
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}

extension Int: RandomValue {
    static func generateRandom() -> Int {
        return Int.random(in: -1000...1000)
    }
}

extension Double: RandomValue {
    static func generateRandom() -> Double {
        return Double.random(in: -1000...1000)
    }
}

extension Bool: RandomValue {
    static func generateRandom() -> Bool {
        return Bool.random()
    }
}

extension Float: RandomValue {
    static func generateRandom() -> Float {
        return Float.random(in: -1000...1000)
    }
}

enum TuplePairGeneraratorConstants {
    static let maxTotal = 10
}

enum SwiftType: String, CaseIterable {
    case string = "String"
    case int = "Int"
    case double = "Double"
    case bool = "Bool"
    case float = "Float"
    
    static func random(excluding: [SwiftType] = []) -> SwiftType {
        let availableTypes = allCases.filter { !excluding.contains($0) }
        return availableTypes.randomElement() ?? .string // Default to string if all types are excluded
    }
    
    func generateRandomValue() -> RandomValue {
        switch self {
        case .string:
            return String.generateRandom()
        case .int:
            return Int.generateRandom()
        case .double:
            return Double.generateRandom()
        case .bool:
            return Bool.generateRandom()
        case .float:
            return Float.generateRandom()
        }
    }
}
