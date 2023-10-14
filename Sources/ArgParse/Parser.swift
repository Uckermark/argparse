import Foundation

/// Parses command-line arguments and returns a struct of the same type.
///
/// - Parameters:
///   - arguments: The struct to be parsed. It must conform to the CommandLineArguments protocol.
/// - Returns: A parsed struct of the same type as the parameter.
internal func _parseCommandLine<T: CommandLineArguments>(_ arguments: T, with args: [String] = Array(CommandLine.arguments.dropFirst())) throws -> T {
    // Initialize the command line arguments array
    var commandLine: [String] = args
    
    // Check if "-h" flag is present, and print help information if found
    if commandLine.contains("-h") {
        throw ArgParseControlError.showHelp
    }
    
    // Initialize a dictionary to store parsed arguments and flags
    var jsonDictionary: [String: Any] = [:]

    // Reflect on the provided arguments struct
    let mirror: Mirror = Mirror(reflecting: arguments)
    for case let (label?, value) in mirror.children {
        let index: String.Index = label.index(after: label.startIndex)
        let variableName: String = String(label[index...])
        
        if var argument: ArgumentProtocol = value as? ArgumentProtocol {
            // Parse argument values
            try argument.parse(arguments: &commandLine, desc: variableName)
            let argumentDict: [String:Any] = [
                "wrappedValue": argument.getValue(),
                "help": argument.getHelp(),
                "id": argument.getID()
            ]
            jsonDictionary[String(label[index...])] = argumentDict
        } else if var flag: FlagProtocol = value as? FlagProtocol {
            // Parse flag values
            try flag.parse(arguments: &commandLine)
            let FlagDict: [String:Any] = [
                "wrappedValue": flag.getValue(),
                "isLong": flag.isKeyLong(),
                "help": flag.getHelp(),
                "key": flag.getKey()
            ]
            jsonDictionary[variableName] = FlagDict
        }
    }
    
    // Check for unknown arguments
    if (!commandLine.allSatisfy { $0.isEmpty }) {
        throw ArgParseError.unknownArguments("Unknown Arguments \(commandLine.filter() { !$0.isEmpty })")
    }
    
    // Serialize the parsed arguments to JSON
    do {
        let jsonData: Data = try JSONSerialization.data(withJSONObject: jsonDictionary, options: [])
        let decoder: JSONDecoder = JSONDecoder()
        
        // Decode the JSON into the provided struct type
        let parsedArguments: T = try decoder.decode(T.self, from: jsonData)
        return parsedArguments
    } catch {
        throw ArgParseError.jsonError(error.localizedDescription)
    }
}

/// Parses command-line arguments into a struct using property wrappers like @Argument or @Flag.
///
/// - Parameter arguments: The struct to be parsed. It must conform to the CommandLineArguments protocol.
/// - Returns: A parsed struct of the same type as the parameter.
public func parseCommandLine<T: CommandLineArguments>(_ arguments: T) -> T {
    do {
        return try _parseCommandLine(arguments)
    } catch let error as ArgParseControlError {
        switch error {
            case .showHelp:
                print(getHelp(arguments))
                exit(0)
        }
    } catch {
        // Print error message and help information in case of an error
        print("ERROR: \(error.localizedDescription)\n")
        print(getHelp(arguments))
        exit(1)
    }
}

/// A protocol that defines the requirements for a parsable struct that can be used with command-line argument parsing.
///
/// Types conforming to `CommandLineArguments` must provide implementations for decoding and encoding their properties
/// from and to command-line arguments. They should also implement the `run` method to define the main logic of the command-line tool.
public protocol CommandLineArguments: Codable {
    /// The entry point for the command-line tool.
    static func main()
    
    /// Runs the command-line tool's main logic.
    ///
    /// - Throws: An error if there is an issue during execution.
    mutating func run() throws


    func validate() throws
    
    /// Initializes a new instance of the conforming type.
    init()
}

public extension CommandLineArguments {
    /// The default entry point for the command-line tool.
    ///
    /// This function initializes an instance of the conforming type, parses command-line arguments into it,
    /// and then invokes the `run` method to execute the main logic of the tool.
    static func main() {
        var args: Self = parseCommandLine(Self())
        do {
            try args.validate()
        } catch {
            print("ERROR: \(error.localizedDescription)\n")
            print(getHelp(Self()))
            exit(1)
        }
        do {
            try args.run()
        } catch {
            print("ERROR: \(error.localizedDescription)")
            exit(2)
        }
    }

    func validate() throws {
        return
    }
}

