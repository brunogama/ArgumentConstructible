//
//  VariadicArgumentConstructable.swift
//  VariadicArgumentConstructable
//
//  Created by Bruno on 20/10/24.
//

/// A protocol that enables types to be constructed from a set of arguments by unpacking and validating them.
///
/// Conforming types must specify the `ArgumentTypes` as a tuple representing the expected types of the arguments.
/// The protocol provides a static `construct` method to create an instance from the provided arguments.
///
/// Example usage:
/// ```swift
/// struct Author {
///     let name: String
///     let birthYear: Int
/// }
///
/// extension Author: VariadicArgumentConstructable {
///     typealias ArgumentTypes = (name: String, birthYear: Int)
///
///     static func construct<each T>(_ args: repeat each T) throws -> Self {
///         let (name, birthYear) = try unpack(repeat each args)
///         return Author(name: name, birthYear: birthYear)
///     }
/// }
/// ```
public protocol VariadicArgumentConstructable: Sendable {
    
    /// A tuple representing the expected types of the arguments required to construct an instance.
    ///
    /// Conforming types must define this `associatedtype` to match the types and order of the arguments.
    associatedtype ArgumentTypes
    
    /// Constructs an instance of the conforming type from the provided arguments.
    ///
    /// This method unpacks the variadic arguments, validates their types against `ArgumentTypes`,
    /// and initializes a new instance of the conforming type.
    ///
    /// - Parameters:
    ///   - args: A variadic list of arguments used to construct the instance.
    ///
    /// - Throws:
    ///   - `InvalidConstructionArgumentTypestionError.invalidArgumentTypes` if the provided arguments do not match `ArgumentTypes`.
    ///
    /// - Returns: A new instance of the conforming type.
    ///
    /// - Note:
    ///   The order and types of the arguments must exactly match those defined in `ArgumentTypes`.
    static func construct<each T>(_ args: repeat each T) throws -> Self
}

extension VariadicArgumentConstructable {
    
    /// Unpacks and validates the provided arguments against the expected `ArgumentTypes`.
    ///
    /// This helper method constructs a tuple from the variadic arguments and attempts to cast it to `ArgumentTypes`.
    /// If the casting fails, it throws an `InvalidConstructionArgumentTypestionError`.
    ///
    /// - Parameters:
    ///   - args: A variadic list of arguments to unpack.
    ///
    /// - Throws:
    ///   - `InvalidConstructionArgumentTypestionError.invalidArgumentTypes` if the argument types do not match `ArgumentTypes`.
    ///
    /// - Returns: A tuple of type `ArgumentTypes` containing the unpacked and validated arguments.
    @inline(never)
    public static func unpack<each T>(_ args: repeat each T) throws -> ArgumentTypes {
        let tuple = (repeat each args)
        guard let castedTuple = tuple as? ArgumentTypes else {
            throw InvalidConstructionArgumentTypestionError(expected: ArgumentTypes.self, actual: type(of: tuple))
        }
        return castedTuple
    }
}
