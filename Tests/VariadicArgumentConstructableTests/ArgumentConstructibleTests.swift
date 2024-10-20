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
        #expect(throws: ArgumentConstructionError.self) {
            try Author.construct(1, true)
        }
    }
}

