import SwiftUI

struct ArTankView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            FishTankARView()
                .ignoresSafeArea()
            
            
            Button {
                viewRouter.currentScreen = .homeScreen
            } label: {
                Image(systemName: "cube.fill")
                    .font(.system(size: 40))
            }
            .offset(x: screenWidth / 2 - 50, y: -screenHeight / 2 + 50)
            
        }
    }
}

struct ArTankView_Previews: PreviewProvider {
    static var previews: some View {
        ArTankView()
    }
}
