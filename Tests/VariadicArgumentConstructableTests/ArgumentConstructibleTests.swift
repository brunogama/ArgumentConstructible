import Testing
import Foundation
@testable import VariadicArgumentConstructable

@Suite("ArgumentConstructibleTests")
struct ArgumentConstructibleTests {
    
    static let maxRandomValues = 10
    
    static func generateArrayOfUUIDS(count: Int) -> [String] {
        return (1...count).map { _ in UUID().uuidString }
    }
    
    static func generateArrayOfInts(count: Int) -> [Int] {
        return (1...count).map { _ in Int.random(in: 1900...2022) }
    }
    
    @Test("Test some random values", arguments: zip( Self.generateArrayOfUUIDS(count: Self.maxRandomValues), Self.generateArrayOfInts(count: Self.maxRandomValues)))
    func validTypeCreation(name: String, birthDay: Int) throws {
        struct Author: VariadicArgumentConstructable {
            let name: String
            let birthYear: Int
            
            typealias ArgumentTypes = (name: String, birthYear: Int)
            
            static func construct<each T>(_ args: repeat each T) throws -> Self {
                let (name, birthYear) = try unpack(repeat each args)
                return Author(name: name, birthYear: birthYear)
            }
        }
        
        let name = "John Doe"
        let birthYear = 1980
        let author = try Author.construct(name, birthYear)
        #expect(author.name == name)
        #expect(author.birthYear == birthYear)
    }
    
    @Test("Test invalid parameter passed using ArgumentType with labeled tuples")
    func test_invalidArgumentType_ArgumentTypeWithLabeledTuples_shouldThrowError() async throws {
        struct Author: VariadicArgumentConstructable {
            let name: String
            let birthYear: Int
            
            typealias ArgumentTypes = (name: String, birthYear: Int)
            
            static func construct<each T>(_ args: repeat each T) throws -> Self {
                let (name, birthYear) = try unpack(repeat each args)
                return Author(name: name, birthYear: birthYear)
            }
        }
        
        #expect {
            try Author.construct(1, true)
        } throws: { error in
            guard let error = error as? ArgumentConstructionError else {
                return false
            }
            
            let expectedMessage = "Invalid argument types. Expected (name: String, birthYear: Int), but got (Int, Bool). Verify if typealias of ArgumentTypes is a tuple corresponding to the values that need to be unpacked."
            
            return error.description == expectedMessage
        }
    }
    
    @Test("Test invalid parameter passed using ArgumentType without labeled tuples should throw error.")
    func test_invalidArgumentType_ArgumentTypeWithoutLabeledTuples_shouldThrowError() async throws {
        struct Author: VariadicArgumentConstructable {
            let name: String
            let birthYear: Int
            
            typealias ArgumentTypes = (String, Int)
            
            static func construct<each T>(_ args: repeat each T) throws -> Self {
                let (name, birthYear) = try unpack(repeat each args)
                return Author(name: name, birthYear: birthYear)
            }
        }
        
        #expect {
            try Author.construct(1, true)
        } throws: { error in
            guard let error = error as? ArgumentConstructionError else {
                return false
            }
            
            let expectedMessage = "Invalid argument types. Expected (String, Int), but got (Int, Bool). Verify if typealias of ArgumentTypes is a tuple corresponding to the values that need to be unpacked."
            
            return error.description == expectedMessage
        }
    }
    
    @Test("Test extra argument passed to construct with two first right types parameter passed using ArgumentType without labeled tuples should throw error.")
    func test_firstArgumentsValidAddingExtraInvalidArgumentType_ArgumentTypeWithoutLabeledTuples_shouldThrowError() async throws {
        struct Author: VariadicArgumentConstructable {
            let name: String
            let birthYear: Int
            
            typealias ArgumentTypes = (String, Int)
            
            static func construct<each T>(_ args: repeat each T) throws -> Self {
                let (name, birthYear) = try unpack(repeat each args)
                return Author(name: name, birthYear: birthYear)
            }
        }
        let name = "John Doe"
        let birthYear = 1980
        #expect {
            try Author.construct(name, birthYear, UUID().uuidString)
        } throws: { error in
            guard let error = error as? ArgumentConstructionError else {
                return false
            }
            
            let expectedMessage = "Invalid argument types. Expected (String, Int), but got (String, Int, String). Verify if typealias of ArgumentTypes is a tuple corresponding to the values that need to be unpacked."
            
            return error.description == expectedMessage
        }
    }
}

