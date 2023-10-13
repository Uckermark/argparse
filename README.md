# ArgParse - A Lightweight Command-Line Argument Parser for Swift

## Overview
ArgParse is a lightweight command-line argument parser for Swift, designed to simplify the process of parsing arguments and flags directly into a Swift struct. It offers an alternative to the more extensive ArgumentParser library, making it easier to create command-line tools with minimal configuration.

## Features
- Parse command-line arguments and flags directly into a Swift struct.
- The Flag property wrapper toggles a Bool value if the flag is passed.
- The Argument property wrapper initializes a required String value.
- Automatically generates usage information and a help table for your command-line tool.
- Enforces valid user input, providing error handling for unexpected input.

## Important Notes
- ArgParse is in beta development, and as such, it may contain undiscovered bugs. Use it with caution in production environments.
- While ArgParse aims to be a lightweight alternative to ArgumentParser, some adjustments may still be needed when migrating existing ArgumentParser-based code.

### Public API
```swift
@propertyWrapper struct Argument(help: String) {}
@propertyWrapper struct Flag(key: Name, help: String) {}

protocol CommandLineArguments {
    mutating func run() throws
    static func main() // implemented in ArgParse
}

func parseCommandLineArguments<T: CommandLineArguments>(_ arguments: T) -> T

enum Name {
    case .short(_ name: Character)
    case .long(_ name: String)
}

enum ArgParseError: LocalizedError {
    case externalError(_ error: String)
}
```

### Example Usage
Here's an example of how to use ArgParse to define and run a command-line tool:
```swift
import Foundation
import ArgParse

struct MyCommandLineTool: CommandLineArguments {
    // Define your command-line arguments and flags here using @Argument and @Flag property wrappers.

    // Examples:
    @Argument(help: "Description for arg1")
    public var arg1: String

    @Argument(help: "Description for arg2")
    public var arg2: String

    @Flag(name: .long("long"), help: "Description for long flag1")
    public var flag1: Bool = false

    @Flag(name: .short("s"), help: "Description for short flag2")
    public var flag2: Bool = false

    // Implement the 'run' method to define the main logic of your tool.
    mutating public func run() throws {
        // Your code to process the command-line arguments and flags goes here.
        if arg1 == arg2 {
            throw ArgParseError.externalError("Validation failed") // use .externalError to show help if validation failed
        }
    }

    // Optional: Validate the parsed arguments by your own criteria
    // This will be executed before 'run'
    func validate throws {
        // Validate command-line arguments
    }
}
MyCommandLineTool.main()
```

### Example Help
```
USAGE: ./ArgParse <arg1> <arg2> [<options>]

ARGUMENTS:
  <arg1>                Description for arg1
  <arg2>                Description for arg2

FLAGS:
  --long                Description for long flag1
  -s                    Description for short flag2
  -h                    Show Help.
```
