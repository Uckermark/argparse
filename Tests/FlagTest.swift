import XCTest
@testable import ArgParse

class FlagTests: XCTestCase {
    
    // Helper function to reset the flag state before each test.
    override func setUp() {
        super.setUp()
    }
    
    // MARK: - Test Flag Initialization
    
    func testFlagInitialization() {
        // Arrange
        let expectedName = Name.short("f")
        let expectedHelp = "Test flag"
        
        // Act
        let flag = Flag(wrappedValue: false, name: expectedName, help: expectedHelp)
        
        // Assert
        XCTAssertEqual(flag.getKey(), "f", "Flag key should match")
        XCTAssertEqual(flag.isKeyLong(), false, "Flag should not be long")
        XCTAssertEqual(flag.getHelp(), expectedHelp, "Help description should match")
        XCTAssertEqual(flag.getValue(), false, "Default value should be false")
    }
    
    func testFlagInitializationLong() {
        // Arrange
        let expectedName = Name.long("flag")
        let expectedHelp = "Test flag"
        
        // Act
        let flag = Flag(wrappedValue: false, name: expectedName, help: expectedHelp)
        
        // Assert
        XCTAssertEqual(flag.getKey(), "flag", "Flag key should match")
        XCTAssertEqual(flag.isKeyLong(), true, "Flag should be long")
        XCTAssertEqual(flag.getHelp(), expectedHelp, "Help description should match")
        XCTAssertEqual(flag.getValue(), false, "Default value should be false")
    }
    
    // MARK: - Test Flag Parsing
    
    func testFlagParsingShort() {
        // Arrange
        var flag = Flag(wrappedValue: false, name: Name.short("f"), help: "Test flag")
        var arguments: [String] = ["-f"]
        
        // Act
        do {
            try flag.parse(arguments: &arguments)
            
            // Assert
            XCTAssertEqual(flag.getValue(), true, "Flag value should be true")
        } catch {
            XCTFail("Parsing should not throw an error")
        }
    }
    
    func testFlagParsingLong() {
        // Arrange
        var flag = Flag(wrappedValue: false, name: Name.long("flag"), help: "Test flag")
        var arguments: [String] = ["--flag"]
        
        // Act
        do {
            try flag.parse(arguments: &arguments)
            
            // Assert
            XCTAssertEqual(flag.getValue(), true, "Flag value should be true")
        } catch {
            XCTFail("Parsing should not throw an error")
        }
    }
    
    func testFlagParsingDuplicate() {
        // Arrange
        var flag = Flag(wrappedValue: false, name: Name.short("f"), help: "Test flag")
        var arguments: [String] = ["-f", "-f"]
        
        // Act and Assert
        XCTAssertThrowsError(try flag.parse(arguments: &arguments)) { error in
            guard let argParseError = error as? ArgParseError else {
                XCTFail("Unexpected error type")
                return
            }
            XCTAssertEqual(argParseError.localizedDescription, "Flag -f is passed more than once", "Error should match")
        }
    }
    
    static var allTests = [
        ("testFlagInitialization", testFlagInitialization),
        ("testFlagInitializationLong", testFlagInitializationLong),
        ("testFlagParsingShort", testFlagParsingShort),
        ("testFlagParsingLong", testFlagParsingLong),
        ("testFlagParsingDuplicate", testFlagParsingDuplicate)
    ]
}
