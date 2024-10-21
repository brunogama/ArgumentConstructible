import Testing
import Foundation
import Fakery

@testable import VariadicArgumentConstructable

@Suite("ArgumentConstructibleTests", .serialized)
struct ArgumentConstructibleTests {
 
    @Test("Test some random values",
          arguments: zip(
            FakerFactory.createFaker().randomListOfFullNames(),
            FakerFactory.createFaker().randomListOfYers()
          )
    )
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
    func test_invalidArgumentType_ArgumentTypeWithLabeledTuples_shouldThrowError() throws {
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
            guard let error = error as? InvalidConstructionArgumentTypestionError else {
                return false
            }
            
            return error.expectedAsString != error.actualAsString
        }
    }
    
    @Test("Test invalid parameter passed using ArgumentType without labeled tuples should throw error.")
    func test_invalidArgumentType_ArgumentTypeWithoutLabeledTuples_shouldThrowError() throws {
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
            guard let error = error as? InvalidConstructionArgumentTypestionError else {
                return false
            }
            return error.expectedAsString != error.actualAsString
        }
    }
    
    @Test("Test extra argument passed to construct with two first right types parameter passed using ArgumentType without labeled tuples should throw error.")
    func test_firstArgumentsValidAddingExtraInvalidArgumentType_ArgumentTypeWithoutLabeledTuples_shouldThrowError() throws {
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
            guard let error = error as? InvalidConstructionArgumentTypestionError else {
                return false
            }
            
            return error.expectedAsString != error.actualAsString
        }
    }
    
    @Test(
        "Test randomize labeled tupples array",
        arguments: PairGeneratorFactory.shared.generateRandonPairs(ignoreTypes: [.string, .int])
    )
    func test_randomizedListOfLabeledTupleValus_shouldThrowError(valuePair: Pair<RandomValue, RandomValue>) async throws {
        struct Author: VariadicArgumentConstructable {
            let name: String
            let birthYear: Int
            
            typealias ArgumentTypes = (String, Int)
            
            static func construct<each T>(_ args: repeat each T) throws -> Self {
                let (name, birthYear) = try unpack(repeat each args)
                return Author(name: name, birthYear: birthYear)
            }
        }
        
        let value0 = try #require(valuePair.left)
        let value1 = try #require(valuePair.right)
        
        #expect {
            try Author.construct(value0, value1)
        } throws: { error in
            guard let error = error as? InvalidConstructionArgumentTypestionError else {
                return false
            }
            
            return error.expectedAsString != error.actualAsString
        }
    }
    
    @Test(
        "Test randomize tupples array",
        arguments: PairGeneratorFactory.shared.generateRandonPairs(ignoreTypes: [.string, .int])
    )
    func test_randomizedListOfNotLabeledTupleValus_shouldThrowError(valuePair: Pair<RandomValue, RandomValue>) async throws {
        struct Author: VariadicArgumentConstructable {
            let name: String
            let birthYear: Int
            
            typealias ArgumentTypes = (String, Int)
            
            static func construct<each T>(_ args: repeat each T) throws -> Self {
                let (name, birthYear) = try unpack(repeat each args)
                return Author(name: name, birthYear: birthYear)
            }
        }
        
        let value0 = try #require(valuePair.left)
        let value1 = try #require(valuePair.right)
        
        #expect {
            try Author.construct(value0, value1)
        } throws: { error in
            guard let error = error as? InvalidConstructionArgumentTypestionError else {
                return false
            }
            return error.expectedAsString != error.actualAsString
        }
    }
}

