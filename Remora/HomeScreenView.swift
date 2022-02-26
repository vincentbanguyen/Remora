import SwiftUI


struct HomeScreenView: View {
    @State private var phrase = "Good job"
    let name = UserDefaults.standard.string(forKey: "name") ?? "Bob"
    @State private var waterDrank = 2
    let timeSinceDrank = Date().timeIntervalSinceReferenceDate - UserDefaults.standard.double(forKey: "timeSinceDrank") ?? Date().timeIntervalSinceReferenceDate
    
    func decreaseWater() {
        if(timeSinceDrank > 3600) {
            waterDrank = waterDrank - Int(round(timeSinceDrank/3600))
        }
    }
    
    var body: some View {
        
        
        ZStack {
            
            Color(hex: "F2F9FF")
                .ignoresSafeArea()
            
            // Top Message
            VStack(alignment: .leading){
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
            
            // Tank View
            FishTankARView()
                .frame(width: 400, height: 400)
        }.onAppear{decreaseWater()}
        .transition(.backslide)
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
