import SwiftUI

@main
struct AlgorithmLearningApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
#if os(macOS)
                .frame(minWidth: 900, minHeight: 680)
#endif
        }
#if os(macOS)
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
