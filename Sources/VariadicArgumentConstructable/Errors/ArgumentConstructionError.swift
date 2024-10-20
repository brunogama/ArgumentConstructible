//
//  ArgumentConstructionError.swift
//  VariadicArgumentConstructable
//
//  Created by Bruno on 20/10/24.
//

/// An error type representing failures during argument construction.
///
/// - invalidArgumentTypes: Indicates that the provided arguments do not match the expected types.
///   - expected: The expected tuple type of arguments.
///   - actual: The actual tuple type of the provided arguments.
public enum ArgumentConstructionError: Error, CustomStringConvertible {
    case invalidArgumentTypes(expected: Any.Type, actual: Any.Type)
    
    /// A textual description of the error.
    public var description: String {
        switch self {
        case .invalidArgumentTypes(let expected, let actual):
            return "Invalid argument types. Expected \(expected), but got \(actual). Verify if typealias of ArgumentTypes is a tuple corresponding to the values that need to be unpacked."
        }
    }
}
