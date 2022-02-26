import SwiftUI

struct OnboardingNameView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var name = ""
    var body: some View {
        ZStack {
            Color(hex: "478ECD")
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Welcome to Remora! \n\n\nTo get started,\nWhat is your name?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: "D2F4FF"))
                        .frame(width: 350, height: 200, alignment: .leading)
                        .padding(.top, 30)
                    
                    VStack {
                        
                        CustomTextField(text: $name, placeholder: "Name", textColor: Color(hex: "D2F4FF"))
                            .frame(width: 300, height: 30, alignment: .leading)
                        
                        Rectangle()
                            .fill(Color(hex: "27486D"))
                            .cornerRadius(20)
                            .frame(width: 300, height: 12)
                    }
                    .padding(.top, 60)
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        viewRouter.currentScreen = .onboardingWeight
                        UserDefaults.standard.set(name, forKey: "name")
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(hex: "27486D"))
                            .cornerRadius(20)
                            .frame(width: 200, height: 50)
                        
                        Text("Next")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color(hex: "D2F4FF"))
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .transition(.slide)
    }
}


struct OnboardingWeightView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var weight = ""
    var body: some View {
        ZStack {
            Color(hex: "C5E3FF")
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading) {
                    Text("Remora calculates your recommended daily water intake \n\nHow much do you weigh?")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .frame(width: 350, height: 200, alignment: .leading)
                        .padding(.top, 30)
                    
                    VStack {
                        HStack {
                        CustomTextField(text: $weight, placeholder: "Weight", textColor: .black)
                            .frame(width: 250, height: 30, alignment: .leading)
                            Text("lbs")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                        }
                        
                        Rectangle()
                            .fill(Color(hex: "27486D"))
                            .cornerRadius(20)
                            .frame(width: 300, height: 12)
                    }
                    .padding(.top, 60)
                    
                }
                Spacer()
                
                ZStack {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 35, weight: .heavy))
                        .offset(x: -140)
                        .foregroundColor(Color(hex: "black"))
                        .onTapGesture {
                            withAnimation {
                                viewRouter.currentScreen = .onboardingName
                            }
                        }
                    
                    Button {
                        withAnimation {
                            viewRouter.currentScreen = .homeScreen
                            UserDefaults.standard.set(weight, forKey: "weight")
                        }
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(Color(hex: "78BAF6"))
                                .cornerRadius(20)
                                .frame(width: 200, height: 50)
                            
                            Text("Get Started")
                                .font(.system(size: 28, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .transition(.backslide)
    }
}

struct OnboardingViews_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingNameView()
            OnboardingWeightView()
        }
    }
}
