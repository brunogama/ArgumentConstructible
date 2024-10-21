//
//  FakerFactory.swift
//  VariadicArgumentConstructable
//
//  Created by Bruno on 20/10/24.
//

import Fakery
import Foundation

class FakerFactory {
    private static let queue = DispatchQueue(label: "com.example.fakerfactory", attributes: .concurrent)
    
    static func createFaker() -> Faker {
        queue.sync {
            Faker()
        }
    }
}
