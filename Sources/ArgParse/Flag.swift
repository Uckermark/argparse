import Foundation

/// A property wrapper for defining command-line flags.
///
/// Flags represent boolean values that can be set via command-line arguments.
/// They are typically used to enable or disable specific behavior in a command-line tool.
/// Flags can have both short (e.g., "-f") and long (e.g., "--flag") names, along with help descriptions.
///
/// - Parameters:
///   - wrappedValue: The initial value of the flag.
///   - name: The name of the flag, which can be short (single-character) or long (multi-character).
///   - help: A description of the flag's purpose.
@propertyWrapper
public struct Flag: Codable {
    /// The key associated with the flag.
    let key: String
    
    /// The help description of the flag.
    let help: String
    
    /// Indicates whether the flag name is long (multi-character).
    let isLong: Bool
    
    /// The current value of the flag.
    public var wrappedValue: Bool

    /// Initializes a new flag with the provided values.
    ///
    /// - Parameters:
    ///   - wrappedValue: The initial value of the flag.
    ///   - name: The name of the flag, which can be short (single-character) or long (multi-character).
    ///   - help: A description of the flag's purpose.
    public init(wrappedValue: Bool, name: Name, help: String) {
        switch name {
            case .short:
                self.isLong = false
            case .long:
                self.isLong = true
        }
        self.key = name.key
        self.help = help
        self.wrappedValue = wrappedValue
    }
}

/// A protocol for defining command-line flags.
///
/// This protocol defines the methods required for parsing, accessing, and providing help information for flags.
internal protocol FlagProtocol {
    /// Parses the flag's value from command-line arguments.
    ///
    /// - Parameter arguments: The inout array of command-line arguments.
    /// - Throws: An error if there is an issue while parsing the flag.
    mutating func parse(arguments: inout [String]) throws
    
    /// Retrieves the current value of the flag.
    ///
    /// - Returns: The boolean value of the flag.
    func getValue() -> Bool
    
    /// Retrieves the help description of the flag.
    ///
    /// - Returns: A string containing the flag's help description.
    func getHelp() -> String
    
    /// Retrieves the key (name) of the flag.
    ///
    /// - Returns: The key associated with the flag, which can be short or long.
    func getKey() -> String
    
    /// Checks if the flag's name is long (multi-character).
    ///
    /// - Returns: `true` if the flag's name is long, otherwise `false`.
    func isKeyLong() -> Bool
}

extension Flag: FlagProtocol {
    /// Parses the flag's value from command-line arguments.
    ///
    /// - Parameter arguments: The inout array of command-line arguments.
    /// - Throws: An error if there is an issue while parsing the flag.
    internal mutating func parse(arguments: inout [String]) throws {
        var duplicate: Bool = false
        for case let (index, argument) in arguments.enumerated() {
            if (self.isLong && argument == "--" + self.key) || (!self.isLong && argument == "-" + self.key) {
                self.wrappedValue.toggle()
                if duplicate {
                    throw ArgParseError.repeatedFlag("Flag -\(self.key) is passed more than once")
                }
                arguments[index] = ""
                duplicate = true
            }
        }
    }
    
    /// Retrieves the current value of the flag.
    ///
    /// - Returns: The boolean value of the flag.
    internal func getValue() -> Bool {
        return self.wrappedValue
    }
    
    /// Retrieves the help description of the flag.
    ///
    /// - Returns: A string containing the flag's help description.
    internal func getHelp() -> String {
        return self.help
    }
    
    /// Retrieves the key (name) of the flag.
    ///
    /// - Returns: The key associated with the flag, which can be short or long.
    internal func getKey() -> String {
        return self.key
    }
    
    /// Checks if the flag's name is long (multi-character).
    ///
    /// - Returns: `true` if the flag's name is long, otherwise `false`.
    internal func isKeyLong() -> Bool {
        return self.isLong
    }
}
