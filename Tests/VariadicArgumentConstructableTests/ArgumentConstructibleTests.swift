import Testing
@testable import VariadicArgumentConstructable

@Suite()
struct ArgumentConstructibleTests {
    
    @Test
    func validTypeCreation() throws {
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
    func testInvalidParameterPassedUsingArgumentTypesWithLabeledTuplesAndExpectedErrorMessage() async throws {
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
    
    @Test("Test invalid parameter passed to the construct ArgumentType with not labeled tuples and expected error message")
    func testInvalidParameterPassedUsingArgumentTypesWithTuplesWithNoLabelAndExpectedErrorMessage() async throws {
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
}

