//
//  printInstanceDetails.swift
//  VariadicArgumentConstructable
//
//  Created by Bruno on 20/10/24.
//

public func printInstanceDetails(_ instance: Any, indent: String = "") {
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
