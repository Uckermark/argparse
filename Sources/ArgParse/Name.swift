import Foundation

/// An enumeration that represents flag names.
///
/// Flag names can be either .short for single-character flags (e.g., "-f") or .long for multi-character flags (e.g., "--flag").
public enum Name {
    /// Represents a single-character flag name.
    case short(_ name: Character)
    
    /// Represents a multi-character flag name.
    case long(_ name: String)
}

extension Name {
    /// Computes the string key associated with the flag name.
    ///
    /// For .short names, the key is a single character (e.g., "f").
    /// For .long names, the key is the full name (e.g., "flag").
    var key: String {
        switch self {
        case let .short(name):
            return String(name)
        case let .long(name):
            return name
        }
    }
}
