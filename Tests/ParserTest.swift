import XCTest
@testable import ArgParse

class CommandLineParserTests: XCTestCase {
    

    override func setUp() {
        super.setUp()
        argumentCount = 0
    }

    // Define a sample command-line arguments structure for testing
    public struct SampleArguments: CommandLineArguments {
        @Argument(help: "Description for argument1")
        var argument1: String

        @Flag(name: .long("long"), help: "Description for long flag")
        var flag1: Bool = false

        mutating func run() throws {
            // Implementation not required for testing
        }
    }
    
    func testParseCommandLine() {
        // Arrange
        let arguments = ["value1", "--long"]
        
        // Act
        do {
            let parsedArguments = try _parseCommandLine(SampleArguments(), with: arguments)
            XCTAssertNotNil(parsedArguments, "Parsing should not return nil")
            XCTAssertEqual(parsedArguments.argument1, "value1", "Argument should be correctly parsed")
            XCTAssertTrue(parsedArguments.flag1, "Flag should be correctly parsed")
        } catch {
            XCTFail("Could not parse Arguments: \(error.localizedDescription)")
        }
        
        // Assert
    }
    
    func testParseCommandLineWithInvalidArguments() {
        // Arrange
        let arguments = ["./app", "--invalidFlag"]
        
        // Act
        do {
            let _ = try _parseCommandLine(SampleArguments(), with: arguments)
            XCTFail("Parsing should throw an error for invalid arguments")
        } catch let error as ArgParseError {
            XCTAssertEqual(error.localizedDescription, "Unknown Arguments [\"--invalidFlag\"]", "Error should match")
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    func testParseCommandLineWithHelpFlag() {
        // Arrange
        let arguments = ["-h"]
        
        // Act
        let parsedArguments = try? _parseCommandLine(SampleArguments(), with: arguments)
        
        // Assert
        XCTAssertNil(parsedArguments, "Parsing should return nil when -h flag is present")
    }
    
    func testParseCommandLineWithUnknownFlag() {
        // Arrange
        let arguments = ["value1", "--unknownFlag"]
        
        // Act
        do {
            let _ = try _parseCommandLine(SampleArguments(), with: arguments)
            XCTFail("Parsing should throw an error for unknown flags")
        } catch let error as ArgParseError {
            XCTAssertEqual(error.localizedDescription, "Unknown Arguments [\"--unknownFlag\"]", "Error should match")
        } catch {
            XCTFail("Unexpected error type")
        }
    }
    
    static var allTests = [
        ("testParseCommandLine", testParseCommandLine),
        ("testParseCommandLineWithInvalidArguments", testParseCommandLineWithInvalidArguments),
        ("testParseCommandLineWithHelpFlag", testParseCommandLineWithHelpFlag),
        ("testParseCommandLineWithUnknownFlag", testParseCommandLineWithUnknownFlag)
    ]
}
