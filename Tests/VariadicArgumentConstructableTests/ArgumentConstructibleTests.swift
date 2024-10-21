import Testing
import Foundation
import Fakery

@testable import VariadicArgumentConstructable

class FakerFactory {
    private static let queue = DispatchQueue(label: "com.example.fakerfactory", attributes: .concurrent)
    
    static func createFaker() -> Faker {
        queue.sync {
            Faker()
        }
    }
}

@Suite("ArgumentConstructibleTests")
struct ArgumentConstructibleTests {
 
    static let randomListOfLabeledTupes = Self.generateListOfLabeledTupples()
    static let randomListOfNotLabeledTupes = Self.generateListOfLabeledTupples()
 
    static func generateListOfLabeledTupples(
        ignoreTypes: [SwiftType] = []
    ) -> [(arg1: RandomValue, arg2: RandomValue)] {
        let type = SwiftType.random(excluding: ignoreTypes)
        return (1...10).map { _ in
            (arg1: type.generateRandomValue(), arg2: type.generateRandomValue())
        }
    }
    
    static func generateListOfNotLabeledTupples(
        ignoreTypes: [SwiftType] = []
    ) -> [(RandomValue, RandomValue)] {
        let type = SwiftType.random(excluding: ignoreTypes)
        return (1...10).map { _ in
            (type.generateRandomValue(), type.generateRandomValue())
        }
    }
    
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
            guard let error = error as? InvalidConstructionArgumentTypestionError else {
                return false
            }
            
            return error.expectedAsString != error.actualAsString
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
            guard let error = error as? InvalidConstructionArgumentTypestionError else {
                return false
            }
            return error.expectedAsString != error.actualAsString
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
            guard let error = error as? InvalidConstructionArgumentTypestionError else {
                return false
            }
            
            return error.expectedAsString != error.actualAsString
        }
    }
    
    @Test(
        "Test randomize labeled tupples array",
        arguments: Self.randomListOfLabeledTupes
    )
    func test_randomizedListOfLabeledTupleValus_shouldThrowError(tuple: (arg1: RandomValue, arg2: RandomValue)) async throws {
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
            try Author.construct(tuple.0, tuple.1)
        } throws: { error in
            guard let error = error as? InvalidConstructionArgumentTypestionError else {
                return false
            }
            
            return error.expectedAsString != error.actualAsString
        }
    }
    
    @Test(
        "Test randomize tupples array",
        arguments: Self.randomListOfLabeledTupes
    )
    func test_randomizedListOfNotLabeledTupleValus_shouldThrowError(tuple: (RandomValue, RandomValue)) async throws {
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
            try Author.construct(tuple.0, tuple.1)
        } throws: { error in
            guard let error = error as? InvalidConstructionArgumentTypestionError else {
                return false
            }
            print(error.description)
            return error.expectedAsString != error.actualAsString
        }
    }
}

