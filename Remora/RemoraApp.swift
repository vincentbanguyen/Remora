import SwiftUI

@main
struct RemoraApp: App {
    @State var loadingDone = false
    var body: some Scene {
        WindowGroup {
            
            if loadingDone == false {
            LoadingView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        loadingDone = true
                    }
                }
            } else {
                ContentView()
            }
            
            
        }
    }
}
