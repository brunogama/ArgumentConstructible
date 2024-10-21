//
//  SafeFaker.swift
//  VariadicArgumentConstructable
//
//  Created by Bruno on 20/10/24.
//


import Fakery

extension Faker {
    func randomFullName() -> String {
        "\(name.firstName()) \(name.lastName())"
    }
    
    func randomYears() -> Int {
        number.randomInt(min: 1900, max: 2021)
    }
    
    func randomListOfFullNames() -> [String] {
        (1...10).compactMap { _ in randomFullName() }
    }
    
    func randomListOfYers() -> [Int] {
        (1...10).compactMap { _ in randomYears() }
    }
}
