import SwiftUI

struct ContentView: View {
    @StateObject private var userDataService = UserDataService()
    @StateObject private var exerciseDataService = ExerciseDataService()
    
    var body: some View {
        Group {
            if userDataService.currentUser != nil {
                MainTabView()
                    .environmentObject(userDataService)
                    .environmentObject(exerciseDataService)
            } else {
                OnboardingView()
                    .environmentObject(userDataService)
            }
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject var userDataService: UserDataService
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Dashboard")
                }
            
            WorkoutView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Workout")
                }
            
            ExerciseLibraryView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Exercises")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .accentColor(.blue)
    }
}

struct OnboardingView: View {
    @EnvironmentObject var userDataService: UserDataService
    @State private var name = ""
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var unitSystem: UnitSystem = .metric
    @State private var height2 = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("MetaFit")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Your Fitness Journey Starts Here")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Form
                VStack(spacing: 20) {
                    Picker("Unit System", selection: $unitSystem) {
                        ForEach(UnitSystem.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)

                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                    
                    HStack {
                        TextField("Age", text: $age)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        if unitSystem == .metric {
                            TextField("Height (cm)", text: $height)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                    }

                    if unitSystem == .imperial {
                        HStack {
                            TextField("Height (ft)", text: $height)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                            TextField("Height (in)", text: $height2)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    TextField(unitSystem == .metric ? "Weight (kg)" : "Weight (lbs)", text: $weight)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                .padding(.horizontal)
                
                // Start Button
                Button(action: createProfile) {
                    Text("Start Your Journey")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(name.isEmpty || age.isEmpty || height.isEmpty || weight.isEmpty)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func createProfile() {
        guard let ageInt = Int(age) else {
            alertMessage = "Please enter a valid number for age."
            showingAlert = true
            return
        }
        
        var heightInCm: Double?
        var weightInKg: Double?

        if unitSystem == .metric {
            guard let heightDouble = Double(height), let weightDouble = Double(weight) else {
                alertMessage = "Please enter valid numbers for height and weight."
                showingAlert = true
                return
            }
            heightInCm = heightDouble
            weightInKg = weightDouble
        } else {
            guard let feet = Double(height), let inches = Double(height2), let lbs = Double(weight) else {
                alertMessage = "Please enter valid numbers for height and weight."
                showingAlert = true
                return
            }
            heightInCm = UnitConverter.feetAndInchesToCm(feet: feet, inches: inches)
            weightInKg = UnitConverter.lbsToKg(lbs)
        }

        guard let finalHeight = heightInCm, let finalWeight = weightInKg else {
            // This case should ideally not be reached due to guards above
            return
        }
        
        guard ageInt > 0 && ageInt < 120 else {
            alertMessage = "Please enter a valid age between 1 and 120."
            showingAlert = true
            return
        }
        
        guard finalHeight > 50 && finalHeight < 300 else {
            alertMessage = "Please enter a valid height."
            showingAlert = true
            return
        }
        
        guard finalWeight > 20 && finalWeight < 300 else {
            alertMessage = "Please enter a valid weight."
            showingAlert = true
            return
        }
        
        userDataService.createUser(name: name, age: ageInt, height: finalHeight, weight: finalWeight, unitSystem: unitSystem)
    }
}

#Preview {
    ContentView()
} 