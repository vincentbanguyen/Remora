import SwiftUI

struct ContentView: View {
    
    @StateObject var viewRouter = ViewRouter()
    
    var body: some View {
        ZStack {
            switch viewRouter.currentScreen {
                
            case Screen.onboardingName:
                OnboardingNameView()
                
            case Screen.onboardingWeight:
                OnboardingWeightView()
                
            case Screen.homeScreen:
                HomeScreenView()
                    .onAppear {
                        UserDefaults.standard.set("homeScreen", forKey: "screenState")
                    }
            }
        }
        .environmentObject(viewRouter)
        .onAppear {
            let screenState = UserDefaults.standard.string(forKey: "screenState") ?? "new"
            
            switch screenState {
            case "homeScreen":
                viewRouter.currentScreen = .homeScreen
            case "new":
                viewRouter.currentScreen = .onboardingName
            default:
                viewRouter.currentScreen = .onboardingName
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
