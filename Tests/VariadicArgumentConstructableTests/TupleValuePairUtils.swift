//
//  TuplePairGenerator.swift
//  VariadicArgumentConstructable
//
//  Created by Bruno on 20/10/24.
//

import Foundation

protocol RandomValue: Sendable {}

extension String: RandomValue {}
extension Float: RandomValue {}
extension Bool: RandomValue {}
extension Int: RandomValue {}
extension Double: RandomValue {}


struct Pair<A: Sendable, B: Sendable>: Sendable {
    let left: A
    let right: B
    
    init(
        _ left: A,
        _ right: B
    ) {
        self.left = left
        self.right = right
    }
}

enum SwiftType: String, CaseIterable, Sendable {
    case string = "String"
    case int = "Int"
    case double = "Double"
    case bool = "Bool"
    case float = "Float"
}

struct PairGeneratorFactory: Sendable {
    
    static let shared = PairGeneratorFactory()
    
    private func generateRandomValue(excluding: [SwiftType] = []) -> RandomValue {
//        let availableTypes = SwiftType.allCases.filter { !excluding.contains($0) }
        
        let availableTypes = SwiftType.allCases.reduce(into: [SwiftType]()) { result, type in
            if !excluding.contains(type) {
                result.append(type)
            }
        }
        let type = availableTypes.randomElement() ?? .bool
        switch type {
        case .string:
            let length = Int.random(in: 1...10)
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            return String((0..<length).map { _ in letters.randomElement()! })
        case .int:
            return Int.random(in: -1000...1000)
        case .double:
            return Double.random(in: -1000...1000)
        case .bool:
            return Bool.random()
        case .float:
            return Float.random(in: -1000...1000)
        }
    }
    
    func generateRandonPairs(
        ignoreTypes: [SwiftType] = []
    ) -> [Pair<RandomValue, RandomValue>] {
        let result: [Pair<RandomValue, RandomValue>] = (1...5).map { _ in
            Pair(generateRandomValue(excluding: ignoreTypes), generateRandomValue(excluding: ignoreTypes))
        }
        return result
    }
}
