# ArgumentConstructible

ArgumentConstructible is a protocol helper that uses variadic Generic types introduced in Swift 5.9.

The intent of this protocol is to create types using variadic generic packs and variadic generic values.

## Protocol Implementation 

```swift
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
```

## How to Use

To use construct capabilities of ArgumentConstructible protocol you will need two things.

### 1 - Createa a typealias from the associatedType ArgumentTypes 
The type author is a really simple type which its init expects to receive `name: String` and `birthYear: Int`

```swift

struct Author {
    let name: String
    let birthYear: Int
}

```

The implementation of the type alias must be a tuple corresponding to the values that will be used to initialized the type.

The typealias of ArgumentTypes would look like this:

```swift
    typealias ArgumentTypes = (name: String, birthYear: Int)
```

### 2 - Implementing Construct

The construct methods needs a bit of work. nothing more than 4 lines of code.

```swift
    static func construct<each T>(_ args: repeat each T) throws -> Self {
        let (name, birthYear) = try unpack(repeat each args)
        return Author(name: name, birthYear: birthYear)
    }
```

### 3 - Whole code together

```swift
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

// Usage
do {
    let validAuthor = try Author.construct("F. Scott Fitzgerald", 1896)
    debugPrint(validAuthor) // Outputs Author(name: "F. Scott Fitzgerald", birthYear: 1896)
    let inValidAuthor = try Author.construct("F. Scott Fitzgerald", true)
    debugPrint(inValidAuthor)
} catch {
  // invalidAuthor try fails throwing a detailed information
  //Invalid argument types. Expected (name: String, birthYear: Int), but got (String, Bool). Verify if typealias of ArgumentTypes is a tuple corresponding to the values that need to be unpacked.
  print(error)
}
```

## More sample code

```swift
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

extension Author: ArgumentConstructible {
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
}```
