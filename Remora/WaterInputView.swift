import SwiftUI

struct WaterInputView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let bottomLevel: CGFloat = 600
    let topLevel: CGFloat = 200
    @State private var oldWaterLevel = UserDefaults.standard.integer(forKey: "savedWaterLevel")
    
    @State private var currentWaterLevel = UserDefaults.standard.integer(forKey: "savedWaterLevel")
    
    @State private var ozDrank = { (currentWaterLevel: Int, oldWaterLevel: Int, isDrinking: Bool) -> Int in
        let ozDrank = (currentWaterLevel - oldWaterLevel)
       // print(ozDrank)
        if ozDrank > 0 && isDrinking == true {
            return ozDrank
        } else {
            return 0
        }
    }
    @State private var previousLocationLevel = CGFloat(1000)
    @State private var isDrinking = true
    
    var body: some View {
        ZStack {
            
            Color(hex: "DDEFFF")
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                
                Text("Match the water level to your water bottle")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.black)
                    .padding(30)
                Spacer()
                
            }
            
            Text("+\(ozDrank(currentWaterLevel, oldWaterLevel,isDrinking)) oz")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundColor(Color(hex: "00B3DB"))
                .position(x: screenWidth / 2, y: topLevel - 50)
            
            
            RoundedRectangle(cornerRadius: 10) // Cup
                .frame(width: 150, height: 400)
                .foregroundColor(Color(hex: "ECECEC"))
                .position(x: screenWidth / 2, y: bottomLevel - 200)
            
            
            RoundedRectangle(cornerRadius: 10) // Water
                .foregroundColor(Color(hex: "CBF4FF"))
                .frame(width: 150, height: 800)
                .position(x: screenWidth / 2,y: CGFloat(currentWaterLevel + 400))
                .gesture(
                    dragLevel
                )
                .mask {
                    RoundedRectangle(cornerRadius: 10) // Cup
                        .frame(width: 150, height: 400)
                        .position(x: screenWidth / 2, y: bottomLevel - 200)
                }
            
            VStack {
                
                Spacer()
                
                VStack {
                    Toggle("Hi", isOn: $isDrinking).labelsHidden()
                    Text(isDrinking ? "Drinking" : "Refilling")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "00B3DB"))
                }
                .onChange(of: isDrinking) { isDrinking in
                    if isDrinking == true {
                        oldWaterLevel = currentWaterLevel
                        UserDefaults.standard.set(oldWaterLevel, forKey: "saved")
                    } else {
                            currentWaterLevel = 200
                    }
                }
                .offset(y: -5)
                
                Button {
                    withAnimation {
                        presentationMode.wrappedValue.dismiss()
                        UserDefaults.standard.set(currentWaterLevel, forKey: "savedWaterLevel")
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(hex: "78BAF6"))
                            .cornerRadius(20)
                            .frame(width: 200, height: 50)
                        
                        Text("Save")
                            .font(.system(size: 28, weight: .semibold, design: .rounded))
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(30)
        }
        .transition(.slide)
    }
    
    var dragLevel: some Gesture {
        DragGesture()
            .onChanged { value in
                
                if value.location.y < 600 && value.location.y > 200 {
                    if isDrinking == true {
                        if value.location.y > CGFloat(oldWaterLevel) {
                            currentWaterLevel = Int(value.location.y)
                        }
                    } else {
                        currentWaterLevel = Int(value.location.y)
                    }
                }
                previousLocationLevel = value.location.y
            }
    }
}

struct WaterInputView_Previews: PreviewProvider {
    static var previews: some View {
        WaterInputView()
    }
}
