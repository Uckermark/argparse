import XCTest
@testable import ArgParse

class ArgumentTests: XCTestCase {
    
    // Helper function to reset the argument count before each test.
    override func setUp() {
        super.setUp()
        argumentCount = 0
    }
    
    // MARK: - Test Argument Initialization
    
    func testArgumentInitialization() {
        // Arrange
        let expectedHelp = "Test argument"
        
        // Act
        let argument = Argument(help: expectedHelp)
        
        // Assert
        XCTAssertEqual(argument.getID(), 0, "Argument ID should be 0")
        XCTAssertEqual(argument.getHelp(), expectedHelp, "Help description should match")
        XCTAssertEqual(argument.getValue(), "", "Default value should be an empty string")
    }
    
    // MARK: - Test Argument Parsing
    
    func testArgumentParsing() {
        // Arrange
        var argument = Argument(help: "Test argument")
        var arguments: [String] = ["value1", "value2", "value3"]
        
        // Act
        do {
            try argument.parse(arguments: &arguments, desc: "Test argument")
            
            // Assert
            XCTAssertEqual(argument.getValue(), "value1", "Parsed value should match")
        } catch {
            XCTFail("Parsing should not throw an error")
        }
    }
    
    func testArgumentParsingWithInvalidPosition() {
        // Arrange
        var argument = Argument(help: "Test argument")
        var arguments: [String] = []
        
        // Act and Assert
        XCTAssertThrowsError(try argument.parse(arguments: &arguments, desc: "Test argument")) { error in
            guard let argParseError = error as? ArgParseError else {
                XCTFail("Unexpected error type")
                return
            }
            XCTAssertEqual(argParseError.localizedDescription, "Expected argument <Test argument> at position 0", "Error description should match")
        }
    }
    
    func testArgumentParsingWithFlag() {
        // Arrange
        var argument = Argument(help: "Test argument")
        var arguments: [String] = ["-f"]
        
        // Act and Assert
        XCTAssertThrowsError(try argument.parse(arguments: &arguments, desc: "Test argument")) { error in
            guard let argParseError = error as? ArgParseError else {
                XCTFail("Unexpected error type")
                return
            }
            XCTAssertEqual(argParseError.localizedDescription, "Expected argument <Test argument> at position 0. Got Flag -f", "Error description should match")
        }
    }
    
    static var allTests = [
        ("testArgumentInitialization", testArgumentInitialization),
        ("testArgumentParsing", testArgumentParsing),
        ("testArgumentParsingWithInvalidPosition", testArgumentParsingWithInvalidPosition),
        ("testArgumentParsingWithFlag", testArgumentParsingWithFlag)
    ]
}
