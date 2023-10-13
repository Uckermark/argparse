import Foundation
import ArgParse

struct CommandLine: CommandLineArguments {
    @Argument(help: "Description for arg1")
    public var arg1: String

    @Argument(help: "Description for arg2")
    public var arg2: String

    @Flag(name: .long("long"), help: "Description for long flag1")
    public var flag1: Bool = false

    @Flag(name: .short("s"), help: "Description for short flag2")
    public var flag2: Bool = false

    mutating public func run() throws {
        print("arg1: " + self.arg1)
        print("arg2: " + self.arg2)
        print(self.flag1 ? "flag1 = true" : "flag1 = false")
        print(self.flag2 ? "flag2 = true" : "flag2 = false")
    }

    func validate() throws {
        if arg1 == arg2 {
            throw ArgParseError.externalError("Validation failed")
        }
    }
}
CommandLine.main()
