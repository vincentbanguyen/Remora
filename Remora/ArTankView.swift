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
                    .font(.system(size: 50))
            }
            .offset(x: 130, y: -360)
            
        }
    }
}

struct ArTankView_Previews: PreviewProvider {
    static var previews: some View {
        ArTankView()
    }
}
