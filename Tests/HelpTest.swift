import XCTest
@testable import ArgParse

class HelpGeneratorTests: XCTestCase {
    
    // Define a sample command-line arguments structure for testing
    struct SampleArguments: CommandLineArguments {
        @Argument(help: "Description for argument1")
        var argument1: String

        @Argument(help: "Description for argument2")
        var argument2: String

        @Flag(name: .long("long"), help: "Description for long flag")
        var flag1: Bool = false

        @Flag(name: .short("s"), help: "Description for short flag")
        var flag2: Bool = false

        mutating func run() throws {
            // Implementation not required for testing
        }
    }
    
    func testHelpGeneration() {
        // Arrange
        let sampleArguments = SampleArguments()
        
        // Act
        let helpMessage = getHelp(sampleArguments).replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)
        
        // Assert
        let expectedHelp = """
        USAGE: \(CommandLine.arguments[0]) <argument1> <argument2> [<options>]

        ARGUMENTS:
          <argument1>     Description for argument1
          <argument2>     Description for argument2

        FLAGS:
          --long          Description for long flag
          -s              Description for short flag
          -h              Show Help.\n
        """.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)

        XCTAssertEqual(helpMessage, expectedHelp, "Generated help message should match")
    }

    func testHelpGenerationNoFlags() {
        // Arrange
        struct ArgumentsNoFlags: CommandLineArguments {
            @Argument(help: "Description for argument1")
            var argument1: String

            @Argument(help: "Description for argument2")
            var argument2: String

            mutating func run() throws {
                // Implementation not required for testing
            }
        }
        let sampleArguments = ArgumentsNoFlags()

        // Act
        let helpMessage = getHelp(sampleArguments).replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)

        // Assert
        let expectedHelp = """
        USAGE: \(CommandLine.arguments[0]) <argument1> <argument2>

        ARGUMENTS:
          <argument1>     Description for argument1
          <argument2>     Description for argument2
          -h              Show Help.\n
        """.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression, range: nil)

        XCTAssertEqual(helpMessage, expectedHelp, "Generated help message should match")
    }
    
    static var allTests = [
        ("testHelpGeneration", testHelpGeneration),
        ("testHelpGenerationNoFlags", testHelpGenerationNoFlags)
    ]
}
