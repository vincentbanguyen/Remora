import SwiftUI
import UserNotifications


struct HomeScreenView: View {
    
    @State private var phrase = "Good job"
    let name = UserDefaults.standard.string(forKey: "name") ?? "Bob"
    let waterDrank = 2
    @State private var showingWaterInputSheet = false
    
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var waterLeft = UserDefaults.standard.integer(forKey: "waterLeft") ?? 0
    let timeSinceDrank = Date().timeIntervalSinceReferenceDate - UserDefaults.standard.double(forKey: "timeDrank") ?? Date().timeIntervalSinceReferenceDate
    
    @State private var arMode = false
    @State private var selectedContainer = "flask"
    
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
            if arMode == false {
                FishTankView()
                    .ignoresSafeArea()
                
            } else {
                Color("HomeScreenBackground")
                    .ignoresSafeArea()
                
                FishTankARView()
                    .ignoresSafeArea()
                    .frame(width: screenWidth * 0.85, height: screenHeight * 0.65)
                    .cornerRadius(30)
                    .padding(.top, 30)
                
            }
            
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
            
            Button {
                arMode.toggle()
            } label: {
                if arMode == false {
                Image(systemName: "cube.transparent")
                    .font(.system(size: 40))
                } else {
                    Image(systemName: "cube.fill")
                        .font(.system(size: 40))
                }
            }
            .offset(x: screenWidth / 2 - 50, y: -screenHeight / 2 + 65)
            
            
                HStack {
                    ZStack {
                    Rectangle()
                        
                        .foregroundColor(.white)
                        .mask {
                            Image("flaskmask")
                                .scaleEffect(0.1)
                        }
                        Image("flaskmaskoutline")
                            .scaleEffect(0.1)
                            .frame(width: 80, height: 100)
                    }
                    .frame(width: 80, height: 100)
                    .offset(y: -15)
                    .onTapGesture {
                        selectedContainer = "flaskmask"
                        showingWaterInputSheet = true
                    }
                    
                    ZStack {
                    Rectangle()
                        .foregroundColor(.white)
                        .mask {
                            Image("cupmask")
                                .scaleEffect(0.1)
                        }
                        Image("cupmaskoutline")
                            .scaleEffect(0.1)
                            .frame(width: 80, height: 100)
                    }
                    .frame(width: 80, height: 100)
                    .onTapGesture {
                        selectedContainer = "cupmask"
                        showingWaterInputSheet = true
                    }
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(.white)
                            .mask {
                                Image("mugmask")
                                    .scaleEffect(0.1)
                            }
                        Image("mugmaskoutline")
                            .scaleEffect(0.1)
                            .frame(width: 80, height: 100)
                    }
                    .frame(width: 80, height: 100)
                    .offset(y: 8)
                }
                .offset(y: screenHeight * 0.4)
                .frame(width: screenWidth, height: 80)
                .onTapGesture {
                    selectedContainer = "mugmask"
                    showingWaterInputSheet = true
                }
            
        }
        .onAppear {
            
            decreaseWater()
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                if success {
                    print("All set!")
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }
            
            if UserDefaults.standard.string(forKey: "notif") != "notifSet" {
                let content = UNMutableNotificationContent()
                content.title = "Remora Reminder"
                content.subtitle = "Hey \(name), don't forget to drink water 💧"
                content.sound = UNNotificationSound.default
                
                // show this notification five seconds from now
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
                
                // choose a random identifier
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                // add our notification request
                UNUserNotificationCenter.current().add(request)
                UserDefaults.standard.setValue("notifSet", forKey: "notif")
            }
        }
        .transition(.backslide)
        .sheet(isPresented: $showingWaterInputSheet) {
            WaterInputView(selectedContainer: selectedContainer)
        }
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
