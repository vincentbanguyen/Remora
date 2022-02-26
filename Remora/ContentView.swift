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
                FishTankView()
            }
        }
        .environmentObject(viewRouter)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
