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
    
    @State private var containerMaxOz = 0
    @Binding var selectedContainer: String
    @State private var currentOz = 0
    
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
            
            
            
            Rectangle()
                .frame(width: screenWidth, height: screenHeight * 0.7)
                .foregroundColor(.white)
                .mask {
                    Image(selectedContainer)
                        .resizable()
                    
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 400)
                }
                .position(x: screenWidth / 2, y: bottomLevel - 200)
            
            RoundedRectangle(cornerRadius: 10) // Water
                .foregroundColor(Color(hex: "00B3DB"))
                .frame(width: screenWidth, height: 800)
                .position(x: screenWidth / 2,y: CGFloat(currentWaterLevel + 400))
            
                .mask {
                    Image(selectedContainer)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 400)
                        .position(x: screenWidth / 2, y: bottomLevel - 200)
                }
            
            Image("\(selectedContainer)outline")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 400)
                .position(x: screenWidth / 2, y: bottomLevel - 200)
                .disabled(true)
                .gesture(
                    dragLevel
                )
                .scaleEffect(selectedContainer == "flaskmask" ? 1.04: 1)
                .onAppear {
                    print(selectedContainer)
                }
            
            HStack {
                Spacer()
                
                VStack {
                    Toggle("Hi", isOn: $isDrinking).labelsHidden()
                    Text(isDrinking ? "Drinking" : "Refilling")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                }
                .onChange(of: isDrinking) { isDrinking in
                    if isDrinking == true {
                        oldWaterLevel = currentWaterLevel
                        UserDefaults.standard.set(oldWaterLevel, forKey: "saved")
                    } else {
                        currentWaterLevel = 200
                    }
                }
                .offset(y: -230)
            }
            .padding(30)
            
            VStack(spacing: 20) {
                
                Spacer()
                HStack {
                    
                    Button {
                        containerMaxOz -= 1
                        UserDefaults.standard.setValue(containerMaxOz, forKey: selectedContainer)
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    }
                    
                    Text(" \(currentOz)/\(containerMaxOz) oz")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.black)
                    
                    Button {
                        containerMaxOz += 1
                        UserDefaults.standard.setValue(containerMaxOz, forKey: selectedContainer)
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .foregroundColor(.black)
                    }
                }
                .offset(y: -10)
                
                
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
            .padding(10)
        }
        .transition(.slide)
        .onAppear {
            containerMaxOz = UserDefaults.standard.integer(forKey: selectedContainer)
        }
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
                   
                    print(600 - currentWaterLevel)
                    currentOz = Int(Double(400 - Int(currentWaterLevel - 200)) / 400.0 * Double(containerMaxOz))
                    print(currentOz)
                }
                previousLocationLevel = value.location.y
            }
    }
}

struct WaterInputView_Previews: PreviewProvider {
    @State static var selectedContainer = "flaskmask"
    static var previews: some View {
        WaterInputView(selectedContainer: $selectedContainer)
    }
}
