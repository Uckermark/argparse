import Foundation

var argumentCount: Int = 0

/// A property wrapper for defining command-line arguments.
///
/// Arguments represent string values that can be provided as command-line arguments.
/// They are typically used to receive input or configuration settings from users.
///
/// - Parameters:
///   - wrappedValue: The initial value of the argument (default is an empty string).
///   - help: A description of the argument's purpose.
@propertyWrapper
public struct Argument: Codable {
    /// The unique identifier of the argument.
    let id: Int
    
    /// The help description of the argument.
    let help: String
    
    /// The current value of the argument.
    public var wrappedValue: String

    /// Initializes a new argument with the provided values.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the argument (default is an empty string).
    ///   - help: A description of the argument's purpose.
    public init(wrappedValue: String = "", help: String) {
        self.id = argumentCount
        argumentCount = argumentCount + 1
        self.help = help
        self.wrappedValue = wrappedValue
    }
}

/// A protocol for defining command-line arguments.
///
/// This protocol defines the methods required for parsing, accessing, and providing help information for arguments.
internal protocol ArgumentProtocol {
    /// Parses the argument's value from command-line arguments.
    ///
    /// - Parameters:
    ///   - arguments: The inout array of command-line arguments.
    ///   - desc: The description of the argument.
    /// - Throws: An error if there is an issue while parsing the argument.
    mutating func parse(arguments: inout [String], desc: String) throws
    
    /// Retrieves the current value of the argument.
    ///
    /// - Returns: The string value of the argument.
    func getValue() -> String
    
    /// Retrieves the help description of the argument.
    ///
    /// - Returns: A string containing the argument's help description.
    func getHelp() -> String
    
    /// Retrieves the unique identifier of the argument.
    ///
    /// - Returns: The unique identifier associated with the argument.
    func getID() -> Int
}

extension Argument: ArgumentProtocol {
    /// Parses the argument's value from command-line arguments.
    ///
    /// - Parameters:
    ///   - arguments: The inout array of command-line arguments.
    ///   - desc: The description of the argument.
    /// - Throws: An error if there is an issue while parsing the argument.
    internal mutating func parse(arguments: inout [String], desc: String) throws {
        if self.id < arguments.count {
            let argumentAtPos: String = String(arguments[self.id])
            if argumentAtPos.first == "-" {
                throw ArgParseError.invalidArgument("Expected argument <\(desc)> at position \(self.id). Got Flag \(argumentAtPos)")
            } else {
                self.wrappedValue = argumentAtPos
                arguments[self.id] = ""
            }
        } else {
            throw ArgParseError.missingArgument("Expected argument <\(desc)> at position \(self.id)")
        }
    }
    
    /// Retrieves the current value of the argument.
    ///
    /// - Returns: The string value of the argument.
    internal func getValue() -> String {
        return self.wrappedValue
    }
    
    /// Retrieves the help description of the argument.
    ///
    /// - Returns: A string containing the argument's help description.
    internal func getHelp() -> String {
        return self.help
    }
    
    /// Retrieves the unique identifier of the argument.
    ///
    /// - Returns: The unique identifier associated with the argument.
    internal func getID() -> Int {
        return self.id
    }
}
