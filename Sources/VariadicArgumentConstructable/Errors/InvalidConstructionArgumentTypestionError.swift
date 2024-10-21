//
//  InvalidConstructionArgumentTypestionError.swift
//  VariadicArgumentConstructable
//
//  Created by Bruno on 20/10/24.
//

/// An error type representing failures during argument construction.
///
/// - invalidArgumentTypes: Indicates that the provided arguments do not match the expected types.
///   - expected: The expected tuple type of arguments.
///   - actual: The actual tuple type of the provided arguments.
public struct InvalidConstructionArgumentTypestionError: Error, CustomStringConvertible, Sendable {
    let expected: Any.Type
    let actual: Any.Type
    
    /// A textual description of the error.
    public var description: String {
        "Invalid argument types. Expected \(expected), but got \(actual). Verify if typealias of ArgumentTypes is a tuple corresponding to the values that need to be unpacked."
    }
    
    public var expectedAsString: String { "\(expected)" }
    
    public var actualAsString: String { "\(actual)" }
}
