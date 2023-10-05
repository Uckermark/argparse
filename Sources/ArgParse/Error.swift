import Foundation

/// An enumeration representing possible errors that can occur during command-line argument parsing.
///
/// `ArgParseError` provides distinct error cases for various issues that may arise while parsing command-line arguments.
/// Each case includes a descriptive error message to help identify the specific problem.
public enum ArgParseError: LocalizedError {
    /// An error related to JSON serialization or deserialization.
    case jsonError(_ error: String)
    
    /// An error indicating an invalid command-line argument.
    case invalidArgument(_ error: String)
    
    /// An error indicating a missing command-line argument.
    case missingArgument(_ error: String)
    
    /// An error indicating that a flag was repeated more than once in the command-line arguments.
    case repeatedFlag(_ error: String)
    
    /// An error indicating the presence of unknown or unexpected command-line arguments.
    case unknownArguments(_ error: String)

    /// An error for user argument validation (e.g. in run())
    case externalError(_ error: String)
}

extension ArgParseError {
    /// A localized description of the error.
    public var errorDescription: String? {
        switch self {
        case let .jsonError(error):
            return error
        case let .invalidArgument(error):
            return error
        case let .missingArgument(error):
            return error
        case let .repeatedFlag(error):
            return error
        case let .unknownArguments(error):
            return error
        case let .externalError(error):
            return error
        }
    }
}
