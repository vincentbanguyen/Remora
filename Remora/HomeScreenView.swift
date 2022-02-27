import SwiftUI
import UserNotifications


struct HomeScreenView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var phrase = "Good job"
    @State private var arMode = false
    @State private var selectedContainer = ""
    @State private var showingWaterInputSheet = false
    @State private var waterLeft = UserDefaults.standard.integer(forKey: "waterLeft")
    
    let name = UserDefaults.standard.string(forKey: "name") ?? "Bob"
    let timeSinceDrank = Date().timeIntervalSinceReferenceDate - UserDefaults.standard.double(forKey: "timeDrank")
    
    let waterDrank = 2
    
    let calendar = Calendar.current
    let currentDate = Date(timeInterval: TimeInterval(TimeZone.current.secondsFromGMT(for: Date())), since: Date())
    let now = Date()
    
    @State private var fishTankOpacity = 0
    
    var body: some View {
        
        ZStack {
            if arMode == false {
                
                let _ = DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    fishTankOpacity = 1
                }
                Color("HomeScreenBackground")
                    .ignoresSafeArea()
                
                FishTankView()
                    .ignoresSafeArea()
                    .opacity(Double(fishTankOpacity))
                
            } else {
                Color("HomeScreenBackground")
                    .ignoresSafeArea()
                
                VStack(spacing: -20) {
                    Text("Tap a surface to place the fish tank")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "080809"))
                FishTankARView()
                    .ignoresSafeArea()
                    .frame(width: screenWidth * 0.88, height: screenHeight * 0.55)
                    .cornerRadius(30)
                    .padding(.top, 50)
                    .offset(y: -20)
                
                }
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
            .padding(.top, 60)
            // TOP message
            
            // Tank View
                
                HStack(spacing: screenWidth * 0.6) {
                    
                    Button {
                        viewRouter.currentScreen = .onboardingName
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 40))
                    }
                    Button {
                        arMode.toggle()
                        fishTankOpacity = 1
                    } label: {
                    if arMode == false {
                        Image(systemName: "cube.transparent")
                            .font(.system(size: 40))
                    } else {
                        Image(systemName: "cube.fill")
                            .font(.system(size: 40))
                    }
                }
            }
            .offset(y: -screenHeight / 2 + 65)
            
            // Settings Button
            
            
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
                    self.selectedContainer = "flaskmask"
                    DispatchQueue.main.async {
                        showingWaterInputSheet = true
                    }
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
                    self.selectedContainer = "cupmask"
                    DispatchQueue.main.async {
                        showingWaterInputSheet = true
                    }
                    
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
                .onTapGesture {
                    self.selectedContainer = "mugmask"
                    DispatchQueue.main.async {
                        showingWaterInputSheet = true
                    }
                    
                }
            }
            .offset(y: screenHeight * 0.4)
            .frame(width: screenWidth, height: 80)
        }
        .onAppear {
            decreaseWater()
            setUpNotif()
        }
        .transition(.backslide)
        .sheet(isPresented: $showingWaterInputSheet) {
            WaterInputView(selectedContainer: $selectedContainer)
        }
    }
    
    func setUpNotif() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        if UserDefaults.standard.string(forKey: "notif") != "notifSet" {
            print("setting up notif")
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
    
    func decreaseWater() {
        waterLeft = waterLeft - Int(round(timeSinceDrank/3600))
        if waterLeft < 0 {
            waterLeft = 0
        }
        UserDefaults.standard.set(waterLeft, forKey: "waterLeft")
        print("New water level saved: " + String(waterLeft))
        print(getMinutesSinceMidnight())
    }
    
    func getMinutesSinceMidnight() -> Int {
        return (calendar.component(.hour, from: now) * 60 + calendar.component(.minute, from: now))
    }
    
    func recommendedIntake() -> Int {
        return Int(round(Double(UserDefaults.standard.integer(forKey: "weight")) * 0.75))
    }
}
    

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}
