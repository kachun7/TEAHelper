import AppKit
import SwiftUI

actor ScriptingService {
    private(set) var state = ScriptingPermissionState.initial

    func checkPermission() {
        let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as NSString: false]
        let initialStatus = AXIsProcessTrustedWithOptions(options)
        state = initialStatus ? .success : .failure
    }

    func requestPermission() async throws {
        guard let url = URL(string: URLStrings.accessibility) else {
            throw ScriptingError.invalidAccessibilityURL
        }
        NSWorkspace.shared.open(url)
        let script = """
            tell application "System Event"
                return 1
            end tell
            """
        try await send(script: script)
    }

    func loadCode(line: String) async throws {
        let script = """
        tell application "System Events"
            set isAppRunning to exists process "Warcraft III"
        end tell

        if not isAppRunning then
            return "Warcraft III not found."
        end if
        
        tell application "Warcraft III"
            activate
            delay 1
        end tell
        
        tell application "System Events"
            keystroke return
            set textToType to "\(line)"
            keystroke textToType
            keystroke return
            return "Keystrokes sent successfully."
        end tell
        """
        try await send(script: script)
    }

    private func send(script: String) async throws {
        let task = Process()
        defer {
            task.terminate()
        }
        task.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        task.standardOutput = Pipe()
        task.standardError = Pipe()
        task.arguments = ["-e", script]
        do {
            try task.run()
            task.waitUntilExit()
            if task.terminationStatus != 0 {
                throw ScriptingError.executionFailed(status: Int(task.terminationStatus))
            }
        } catch {
            throw ScriptingError.processError(message: error.localizedDescription)
        }
    }

    private enum URLStrings {
        static let accessibility = "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility"
    }
}
