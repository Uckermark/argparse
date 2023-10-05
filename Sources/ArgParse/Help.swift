import Foundation

/// Generates a help message based on the provided command-line arguments structure.
///
/// This function inspects the given `arguments` structure and constructs a help message
/// that includes information about arguments and flags, their descriptions, and usage.
///
/// - Parameters:
///   - arguments: The command-line arguments structure to generate help for.
///                It must conform to CommandLineArguments and contain properties with property wrappers like @Argument or @Flag.
/// - Returns: A string containing the generated help message.
internal func getHelp<T: CommandLineArguments>(_ arguments: T) -> String {
    // Reflect on the provided arguments structure
    let mirror: Mirror = Mirror(reflecting: arguments)
    
    // Arrays to store argument and flag help information
    var argumentHelp: [(desc: String, help: String)] = []
    var flagHelp: [(key: String, help: String)] = []
    
    // Iterate through the properties of the arguments structure
    for case let (label, value) in mirror.children {
        if let argument: ArgumentProtocol = value as? ArgumentProtocol {
            // Extract and append argument help information
            argumentHelp.append((String(label!.dropFirst()), argument.getHelp()))
        } else if let flag: FlagProtocol = value as? FlagProtocol {
            // Extract and append flag help information
            flagHelp.append((flag.getKey(), flag.getHelp()))
        }
    }
    
    // Construct the usage string based on argument names
    var usageString: String = "\(CommandLine.arguments[0]) "
    if !argumentHelp.isEmpty {
        for (desc, _) in argumentHelp {
            usageString.append("<\(desc)> ")
        }
    }
    if !flagHelp.isEmpty { usageString.append("[<options>]")}
    
    // Initialize the help string with the usage information
    var helpString: String = "USAGE: \(usageString)\n"
    
    // Determine the maximum description length among arguments and flags
    let maxDescLength = max(argumentHelp.map { $0.desc.count }.max() ?? 0, flagHelp.map { $0.key.count }.max() ?? 0)
    
    // Append argument help information to the help string
    if !argumentHelp.isEmpty { helpString.append("\nARGUMENTS:\n")}
    for (desc, help) in argumentHelp {
        let padding: String = String(repeating: " ", count: maxDescLength - desc.count)
        helpString.append("  <\(desc)>\(padding)\t\t\(help)\n")
    }
    
    // Append flag help information to the help string
    if !flagHelp.isEmpty { helpString.append("\nFLAGS:\n")}
    for (name, help) in flagHelp {
        if name.count > 1 {
            let padding: String = String(repeating: " ", count: maxDescLength - name.count)
            helpString.append("  --\(name)\(padding)\t\t\(help)\n")
        } else {
            let padding: String = String(repeating: " ", count: maxDescLength - name.count + 1)
            helpString.append("  -\(name)\(padding)\t\t\(help)\n")
        }
    }
    
    // Append the help option description to the help string
    helpString.append("  -h\(String(repeating: " ", count: maxDescLength))\t\tShow Help.\n")
    
    return helpString
}
