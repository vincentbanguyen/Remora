import SwiftUI


struct HomeScreenView: View {
    @State private var phrase = "Good job"
    let name = UserDefaults.standard.string(forKey: "name") ?? "Bob"
    let waterDrank = 2
    @State private var showingWaterInputSheet = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var waterLeft = UserDefaults.standard.integer(forKey: "waterLeft") ?? 0
    let timeSinceDrank = Date().timeIntervalSinceReferenceDate - UserDefaults.standard.double(forKey: "timeDrank") ?? Date().timeIntervalSinceReferenceDate
    
    func decreaseWater() {
        if(timeSinceDrank > 3600) {
            waterLeft = waterLeft - Int(round(timeSinceDrank/3600))
            if waterLeft < 0 {
                waterLeft = 0
            }
        }
    }
    
    var body: some View {
        ZStack {
            
            Color(hex: "F2F9FF")
                .ignoresSafeArea()
            
            // Top Message
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("\(phrase) \(name)!")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "080809"))
                    
                    HStack(spacing: 0) {
                        
                        Text("You drank ")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "080809"))
                        
                        Text("\(waterDrank) oz")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "00B3DB"))
                        
                        Text(" today :)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "080809"))
                    }
                }
                .frame(width: 350, height: 80, alignment: .leading)
                Spacer()
            }
            .padding(.top, 30)
            // TOP message
            
            // Tank View
            
            FishTankView()
                .frame(width: 400, height: 400)
            
            Button {
                viewRouter.currentScreen = .arTankScreen
            } label: {
                Image(systemName: "cube.transparent")
                    .font(.system(size: 40))
            }
            .offset(x: screenWidth / 2 - 50, y: -screenHeight / 2 + 50)
            
            VStack {
                Spacer()
                Button {
                    showingWaterInputSheet = true
                } label: {
                    Rectangle()
                        .frame(width: 50, height: 20)
                        .foregroundColor(.black)
                }

            }
        }
        .onAppear{ decreaseWater() }
        .transition(.backslide)
        .sheet(isPresented: $showingWaterInputSheet, content: WaterInputView.init)
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
