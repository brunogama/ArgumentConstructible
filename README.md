# ArgumentConstructible

ArgumentConstructible is a protocol helper that uses parameter packs types introduced in Swift 5.9.

To know more about parameter packs watch the WWDC session:

**Generalize APIs with parameter packs**

* Link: https://developer-mdn.apple.com/videos/play/wwdc2023/10168/

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
  // Invalid argument types. Expected (name: String, birthYear: Int), but got (String, Bool). Verify if typealias of ArgumentTypes is a tuple corresponding to the values that need to be unpacked.
  print(error)
}
```

### 4 - Why static function and not a init

The creation of `inits` in protocols are a bit tricky. If you make a class conform to a protocol with a `init` it will be anotated with `required`. Which would impose a `required init` with parameter packs. Making the life of the developer a living hell.

### 5 - Conclusions

Parameter packs are a very nice addtion to Swift 5.9. Learning it how to make it work is hard. That's why we don't see many codes using it.

## Proposals and Ideas

Please feel free to contact me or make a pull request so we can get in touch on how to improve this current implementation.

## More sample code

If you need more sample code there's a Xcode Playground with the Protocol and its extensions and types it relies on.

## License

MIT.
