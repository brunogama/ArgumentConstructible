import Testing
@testable import VariadicArgumentConstructable

@Suite()
struct ArgumentConstructibleTests {
    struct Author: VariadicArgumentConstructable {
        let name: String
        let birthYear: Int
        
        typealias ArgumentTypes = (name: String, birthYear: Int)
        
        static func construct<each T>(_ args: repeat each T) throws -> Self {
            let (name, birthYear) = try unpack(repeat each args)
            return Author(name: name, birthYear: birthYear)
        }
    }
    
    @Test
    func validTypeCreation() throws {
        let name = "John Doe"
        let birthYear = 1980
        let author = try Author.construct(name, birthYear)
        #expect(author.name == name)
        #expect(author.birthYear == birthYear)
    }
    
    @Test
    func validTInvalidTypeCreation() async throws {
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
}

