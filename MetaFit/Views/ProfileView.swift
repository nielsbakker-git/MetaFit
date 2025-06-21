import SwiftUI
import UniformTypeIdentifiers

struct ProfileView: View {
    @EnvironmentObject var userDataService: UserDataService
    @State private var showingEditProfile = false
    @State private var showingAchievements = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = userDataService.currentUser {
                        // Profile Header
                        ProfileHeaderView(user: user)
                        
                        // Stats Overview
                        StatsOverviewCard(user: user)
                        
                        // Achievements
                        AchievementsCard()
                        
                        // Recent Activity
                        RecentActivityCard()
                        
                        // Settings
                        SettingsCard(showingEditProfile: $showingEditProfile)
                    }
                }
                .padding()
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditProfile = true
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView()
            }
            .sheet(isPresented: $showingAchievements) {
                AchievementsView()
            }
        }
    }
}

struct ProfileHeaderView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 15) {
            // Avatar and Level
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .frame(width: 100, height: 100)
                    
                    Text(String(user.name.prefix(1)).uppercased())
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
                
                VStack(spacing: 4) {
                    Text("Level \(user.level)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text("\(user.xpPoints) XP")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            // User Info
            VStack(spacing: 8) {
                Text(user.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                HStack(spacing: 20) {
                    InfoItem(title: "Age", value: "\(user.age)")
                    InfoItem(title: "Height", value: UnitConverter.displayHeight(user.height, in: user.unitSystem))
                    InfoItem(title: "Weight", value: UnitConverter.displayWeight(user.weight, in: user.unitSystem))
                }
                
                // BMI Info
                VStack(spacing: 4) {
                    Text("BMI: \(user.bmi, specifier: "%.1f")")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(user.bmiCategory)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(bmiColor.opacity(0.2))
                        .foregroundColor(bmiColor)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var bmiColor: Color {
        switch user.bmiCategory {
        case "Underweight":
            return .orange
        case "Normal":
            return .green
        case "Overweight":
            return .yellow
        case "Obese":
            return .red
        default:
            return .gray
        }
    }
}

struct InfoItem: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct StatsOverviewCard: View {
    let user: User
    @EnvironmentObject var userDataService: UserDataService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Statistics")
                .font(.headline)
                .fontWeight(.semibold)
            
            let weeklyStats = userDataService.getWeeklyStats()
            let streak = userDataService.getStreakDays()
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                StatCard(
                    title: "Total Workouts",
                    value: "\(user.totalWorkouts)",
                    icon: "dumbbell.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Current Streak",
                    value: "\(streak) days",
                    icon: "flame.fill",
                    color: .orange
                )
                
                StatCard(
                    title: "Total Calories",
                    value: "\(Int(user.totalCaloriesBurned))",
                    icon: "flame.fill",
                    color: .red
                )
                
                StatCard(
                    title: "This Week",
                    value: "\(weeklyStats.totalWorkouts)",
                    icon: "calendar",
                    color: .green
                )
            }
            
            // Progress to next level
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress to Level \(user.level + 1)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(Int(user.progressToNextLevel * 100))%")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                
                ProgressView(value: user.progressToNextLevel)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                
                Text("\(user.xpToNextLevel - (user.xpPoints - (user.level - 1) * 100)) XP to next level")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}

struct AchievementsCard: View {
    @State private var showingAchievements = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Achievements")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                
                Button("View All") {
                    showingAchievements = true
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            // Sample achievements
            VStack(spacing: 10) {
                AchievementRow(
                    title: "First Workout",
                    description: "Complete your first workout",
                    icon: "star.fill",
                    isUnlocked: true
                )
                
                AchievementRow(
                    title: "Week Warrior",
                    description: "Complete 5 workouts in a week",
                    icon: "calendar.badge.clock",
                    isUnlocked: false
                )
                
                AchievementRow(
                    title: "Calorie Burner",
                    description: "Burn 1000 calories in total",
                    icon: "flame.fill",
                    isUnlocked: false
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .sheet(isPresented: $showingAchievements) {
            AchievementsView()
        }
    }
}

struct AchievementRow: View {
    let title: String
    let description: String
    let icon: String
    let isUnlocked: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isUnlocked ? .yellow : .gray)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(isUnlocked ? .primary : .secondary)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
        .padding(.vertical, 4)
    }
}

struct RecentActivityCard: View {
    @EnvironmentObject var userDataService: UserDataService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Recent Activity")
                .font(.headline)
                .fontWeight(.semibold)
            
            let recentWorkouts = Array(userDataService.workouts.prefix(5))
            
            if recentWorkouts.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "clock")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Text("No recent activity")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ForEach(recentWorkouts) { workout in
                    ActivityRowView(workout: workout)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ActivityRowView: View {
    let workout: Workout
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(workout.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(workout.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("+\(workout.xpEarned) XP")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                Text("\(Int(workout.totalCaloriesBurned)) cal")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct SettingsCard: View {
    @EnvironmentObject var userDataService: UserDataService
    @State private var showingResetAlert = false
    @Binding var showingEditProfile: Bool

    private struct UserExportData: Codable {
        let user: User?
        let workouts: [Workout]
    }

    private var userExportData: Data? {
        let exportData = UserExportData(user: userDataService.currentUser, workouts: userDataService.workouts)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(exportData)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Settings")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 0) {
                SettingsRow(
                    title: "Edit Profile",
                    icon: "person.circle",
                    action: { showingEditProfile = true }
                )
                
                Divider()

                if let data = userExportData {
                    ShareLink(item: JSONDocument(data: data, filename: "metafit_data.json"),
                              preview: SharePreview("MetaFit Data Export")) {
                        SettingsRow(
                            title: "Export Data",
                            icon: "square.and.arrow.up",
                            action: { }
                        )
                        .foregroundColor(.primary)
                    }
                }
                
                Divider()
                
                SettingsRow(
                    title: "Reset Progress",
                    icon: "arrow.clockwise",
                    action: { showingResetAlert = true }
                )
                .foregroundColor(.red)
            }
            .background(Color(.systemBackground))
            .cornerRadius(10)

            Section {
                Picker("Unit System", selection: Binding<UnitSystem>(
                    get: { userDataService.currentUser?.unitSystem ?? .metric },
                    set: { userDataService.updateUserSystem($0) }
                )) {
                    ForEach(UnitSystem.allCases, id: \.self) { system in
                        Text(system.rawValue).tag(system)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Preferences")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.top)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .alert("Reset Progress", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                // Reset user progress
            }
        } message: {
            Text("This will reset all your progress, workouts, and XP. This action cannot be undone.")
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                
                Text(title)
                    .font(.subheadline)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditProfileView: View {
    @EnvironmentObject var userDataService: UserDataService
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    @State private var height2 = ""
    @State private var unitSystem: UnitSystem = .metric
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    HStack {
                        Text("Name")
                        TextField("Name", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    HStack {
                        Text("Age")
                        TextField("Age", text: $age)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }

                    if unitSystem == .metric {
                        HStack {
                            Text("Height (cm)")
                            TextField("Height", text: $height)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                        }
                    } else {
                        HStack {
                            Text("Height")
                            TextField("ft", text: $height)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.trailing)
                            Text("'")
                            TextField("in", text: $height2)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                            Text("\"")
                        }
                    }

                    HStack {
                        Text(unitSystem == .metric ? "Weight (kg)" : "Weight (lbs)")
                        TextField("Weight", text: $weight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProfile()
                    }
                }
            }
            .onAppear {
                if let user = userDataService.currentUser {
                    name = user.name
                    age = String(user.age)
                    unitSystem = user.unitSystem

                    if user.unitSystem == .metric {
                        height = String(user.height)
                        weight = String(user.weight)
                    } else {
                        let (ft, inch) = UnitConverter.cmToFeetAndInches(user.height)
                        height = String(ft)
                        height2 = String(format: "%.1f", inch)
                        weight = String(format: "%.1f", UnitConverter.kgToLbs(user.weight))
                    }
                }
            }
        }
    }
    
    private func saveProfile() {
        guard let ageInt = Int(age) else { return }
        
        var heightInCm: Double?
        var weightInKg: Double?

        if unitSystem == .metric {
            heightInCm = Double(height)
            weightInKg = Double(weight)
        } else {
            let ft = Double(height) ?? 0
            let inch = Double(height2) ?? 0
            heightInCm = UnitConverter.feetAndInchesToCm(feet: ft, inches: inch)

            if let lbs = Double(weight) {
                weightInKg = UnitConverter.lbsToKg(lbs)
            }
        }

        guard let finalHeight = heightInCm, let finalWeight = weightInKg else { return }

        if var user = userDataService.currentUser {
            user.name = name
            user.age = ageInt
            user.height = finalHeight
            user.weight = finalWeight
            userDataService.updateUser(user)
        }
        
        dismiss()
    }
}

struct AchievementsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section("Unlocked") {
                    AchievementRow(
                        title: "First Workout",
                        description: "Complete your first workout",
                        icon: "star.fill",
                        isUnlocked: true
                    )
                }
                
                Section("Locked") {
                    AchievementRow(
                        title: "Week Warrior",
                        description: "Complete 5 workouts in a week",
                        icon: "calendar.badge.clock",
                        isUnlocked: false
                    )
                    
                    AchievementRow(
                        title: "Calorie Burner",
                        description: "Burn 1000 calories in total",
                        icon: "flame.fill",
                        isUnlocked: false
                    )
                    
                    AchievementRow(
                        title: "Level Up",
                        description: "Reach level 5",
                        icon: "arrow.up.circle.fill",
                        isUnlocked: false
                    )
                }
            }
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct JSONDocument: Transferable {
    let data: Data
    let filename: String

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .json) { document in
            document.data
        }
        .suggestedFileName { document in
            document.filename
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UserDataService())
} 