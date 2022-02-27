import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentScreen: Screen = .onboardingName
}

enum Screen {
    case onboardingName
    case onboardingWeight
    case homeScreen
    case arTankScreen
    case waterInput
}
