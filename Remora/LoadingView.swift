import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color("HomeScreenBackground")
                .ignoresSafeArea()
            VStack(spacing: 60) {
            
                
            LoadingGIF(name: "Loading")
                .scaleEffect(1.4)
                .frame(width: 200, height: 200)
                .aspectRatio(contentMode: .fit)
                
                Text("Remora")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
            }
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
