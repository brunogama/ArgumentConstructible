import Foundation

func printInstanceDetails(_ instance: Any, indent: String = "") {
    let isSimpleType: (Any) -> Bool = { value in
        return value is String || value is Int || value is Double || value is Bool
    }
    let mirror = Mirror(reflecting: instance)
    print("\(indent)Instance of \(type(of: instance)):")
    for child in mirror.children {
        if let label = child.label {
            print("\(indent)  \(label): ", terminator: "")
            let childMirror = Mirror(reflecting: child.value)
            if childMirror.children.count > 0 && !isSimpleType(child.value) {
                print("")
                printInstanceDetails(child.value, indent: indent + "    ")
            } else {
                print("\(child.value)")
            }
        }
    }
    
    print("-----------------------------------------------------------------")
}


protocol ArgumentConstructible {
    // In order to unpack values from arguments, we need to know the types of the arguments in a tuple
    // This typealias should be defined in conforming types
    // This allows us to validate the types of the arguments and unpack them into the correct tuple types
    associatedtype ArgumentTypes

    static func construct<each T>(_ args: repeat each T) throws -> Self
}

extension ArgumentConstructible {
    @inline(never)
    static func unpack<each T>(_ args: repeat each T) throws -> ArgumentTypes {
        let tuple = (repeat each args)
        guard let castedTuple = tuple as? ArgumentTypes else {
            throw ArgumentConstructionError.invalidArgumentTypes(expected: ArgumentTypes.self, actual: type(of: tuple))
        }
        return castedTuple
    }
}

enum ArgumentConstructionError: Error, CustomStringConvertible {
    case invalidArgumentTypes(expected: Any.Type, actual: Any.Type)

    var description: String {
        switch self {
        case .invalidArgumentTypes(let expected, let actual):
            return "Invalid argument types. Expected \(expected), but got \(actual). Verify if typealias of ArgumentTypes is a tuple corresponding to the values that need to be unpacked."
        }
    }
}

@propertyWrapper
struct Capitalized {
    private var value: String

    var wrappedValue: String {
        get { value }
        set { value = newValue.capitalized }
    }

    init(wrappedValue: String) {
        self.value = wrappedValue.capitalized
    }
}

// Author struct conforming to ArgumentConstructible
struct Author {
    let name: String
    let birthYear: Int
}

extension Author: ArgumentConstructible {
    typealias ArgumentTypes = (name: String, birthYear: Int)

    static func construct<each T>(_ args: repeat each T) throws -> Self {
        let (name, birthYear) = try unpack(repeat each args)
        return Author(name: name, birthYear: birthYear)
    }
}

// Book struct conforming to ArgumentConstructible
struct Book {
    @Capitalized var title: String
    let author: Author
    var pageCount: Int
    var price: Double
}

extension Book: ArgumentConstructible {
    typealias ArgumentTypes = (
        title: String,
        authorName: String,
        authorBirthYear: Int,
        pageCount: Int,
        price: Double
    )

    static func construct<each T>(_ args: repeat each T) throws -> Self {
        let (title, authorName, authorBirthYear, pageCount, price) = try unpack(repeat each args)
        let author = try Author.construct(authorName, authorBirthYear)
        return Book(title: title, author: author, pageCount: pageCount, price: price)
    }
}

// Car struct conforming to ArgumentConstructible
struct Car {
    let make: String
    let model: String
    var year: Int
    var price: Double
}

extension Car: ArgumentConstructible {
    typealias ArgumentTypes = (make: String, model: String, year: Int, price: Double)

    static func construct<each T>(_ args: repeat each T) throws -> Self {
        let (make, model, year, price) = try unpack(repeat each args)
        return Car(make: make, model: model, year: year, price: price)
    }
}

// Usage examples
do {
    let book = try Book.construct("the great gatsby", "F. Scott Fitzgerald", 1896, 180, 12.99)
    printInstanceDetails(book)

    let car = try Car.construct("Tesla", "Model 3", 2023, 49900.00)
    printInstanceDetails(car)

    // This should throw an error due to invalid types
    let _: Car = try Car.construct("Toyota", "Corolla", "2022")
} catch let error as ArgumentConstructionError {
    print("Error: \(error.description)")
} catch {
    print("An unexpected error occurred: \(error)")
}
