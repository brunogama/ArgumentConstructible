``# ArgumentConstructible

`ArgumentConstructible` is a protocol helper that uses *parameter packs* a feature introduced in Swift 5.9.

*Parameter packs* enable functions and types to accept a variable number of generic parameters, enhancing flexibility and code reuse. This feature allows developers to create more abstract and adaptable APIs by seamlessly handling multiple types within a single construct.

**Swift Evolution Proposals**
* https://github.com/swiftlang/swift-evolution/blob/main/proposals/0393-parameter-packs.md
* https://github.com/swiftlang/swift-evolution/blob/main/proposals/0398-variadic-types.md
* https://github.com/swiftlang/swift-evolution/blob/main/proposals/0399-tuple-of-value-pack-expansion.md

To know more about *parameter packs* watch the **WWDC** session:

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

To use construct capabilities of `ArgumentConstructible` protocol you will need two things.

### 1 - Createa a typealias from the `associatedType` `ArgumentTypes` 

The type `Author` is a really simple type which its `init` expects to receive `name: String` and `birthYear: Int`

```swift

struct Author {
    let name: String
    let birthYear: Int
}

```

The implementation of the `typealias` must be a tuple corresponding to the types that will be used on the `init` of the type.

The `typealias` of `ArgumentTypes` would look like this:

```swift
    typealias ArgumentTypes = (name: String, birthYear: Int)
```

### 2 - Implementing Construct

The construct method needs a bit of work nothing more than 4 lines of code.

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

### 4 - Internals of `unpack`

The `unpack(_:)` function works as bridge to convert the *value packs* into the `associatedType ArgumentTypes`. 

About the inline annotation `@inline(never)` at the current day any if you try to type casting a tuple of *value packs* it will throw a compiler warning notfiyng that the cast always fail. But this is not true at present day.

### 5 - Why static function and not adding parameter packs to a `init` into the Protocol

The creation of `inits` in protocols are a bit tricky. If you make a class conform to a protocol with a `init` it will be anotated with `required`. Which would impose a `required init` with parameter packs. Making the life of the developer a living hell.

### 6 - Conclusions

*Parameter packs* are a very nice addtion to Swift 5.9. The curving learn is steep. That's why we don't see many codes on github using it and the articles in the internet explaining how to use it are pretty rare.

**Aricles that apresents the feature**

Some articles to read more about *paramter packs*

* Avanderlee: [Value and Type parameter packs in Swift explained with examples](https://www.avanderlee.com/swift/value-and-type-parameter-packs/)
* Hacking with Swift: [Value and Type Parameter Packs](https://www.hackingwithswift.com/swift/5.9/variadic-generics)
* By Andy Kolean [Value and Type Parameter Packs in Swift](https://medium.com/@andykolean_89531/value-and-type-parameter-packs-in-swift-530e2d95f140)

## Proposals and Ideas

Please feel free to contact me or make a pull request so we can get in touch on how to improve this current implementation.

## More sample code

If you need more sample code there's a Xcode Playground with the Protocol and its extensions and types it relies on.

## License

MIT.
