import VariadicArgumentConstructable

import Foundation

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

struct Author {
    let name: String
    let birthYear: Int
}

extension Author: VariadicArgumentConstructable {
    typealias ArgumentTypes = (name: String, birthYear: Int)

    static func construct<each T>(_ args: repeat each T) throws -> Self {
        let (name, birthYear) = try unpack(repeat each args)
        return Author(name: name, birthYear: birthYear)
    }
}

struct Book {
    @Capitalized var title: String
    let author: Author
    var pageCount: Int
    var price: Double
}

extension Book: VariadicArgumentConstructable {
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

struct Car {
    let make: String
    let model: String
    var year: Int
    var price: Double
}

extension Car: VariadicArgumentConstructable {
    typealias ArgumentTypes = (make: String, model: String, year: Int, price: Double)

    static func construct<each T>(_ args: repeat each T) throws -> Self {
        let (make, model, year, price) = try unpack(repeat each args)
        return Car(make: make, model: model, year: year, price: price)
    }
}

do {
    let book = try Book.construct("the great gatsby", "F. Scott Fitzgerald", 1896, 180, 12.99)
    printInstanceDetails(book)

    let car = try Car.construct("Tesla", "Model 3", 2023, 49900.00)
    printInstanceDetails(car)

    // This should throw an error due to invalid types
    let invalidCar: Car = try Car.construct("Toyota", "Corolla", "2022")
} catch let error as ArgumentConstructionError {
    print("Error: \(error.description)")
} catch {
    // invalidCar throws error with description
    // Invalid argument types. Expected (make: String, model: String, year: Int, price: Double), but got (String, String, String). Verify if typealias of ArgumentTypes is a tuple corresponding to the values that need to be unpacked.
    print("An unexpected error occurred: \(error)")
}
