import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var userDataService: UserDataService
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = userDataService.currentUser {
                        // User Stats Card
                        UserStatsCard(user: user)
                        
                        // Quick Actions
                        QuickActionsCard()
                        
                        // Weekly Progress
                        WeeklyProgressCard()
                        
                        // Recent Workouts
                        RecentWorkoutsCard()
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct UserStatsCard: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome back,")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text(user.name)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Level \(user.level)")
                        .font(.headline)
                        .foregroundColor(.blue)
                    Text("\(user.xpPoints) XP")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Level Progress
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("Progress to Level \(user.level + 1)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("\(Int(user.progressToNextLevel * 100))%")
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                ProgressView(value: user.progressToNextLevel)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WeeklyProgressCard: View {
    @EnvironmentObject var userDataService: UserDataService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("This Week")
                .font(.headline)
                .fontWeight(.semibold)
            
            let stats = userDataService.getWeeklyStats()
            
            HStack(spacing: 20) {
                StatItem(
                    title: "Workouts",
                    value: "\(stats.totalWorkouts)",
                    icon: "dumbbell.fill",
                    color: .blue
                )
                
                StatItem(
                    title: "Calories",
                    value: "\(Int(stats.totalCalories))",
                    icon: "flame.fill",
                    color: .orange
                )
                
                StatItem(
                    title: "XP Earned",
                    value: "\(stats.totalXP)",
                    icon: "star.fill",
                    color: .yellow
                )
            }
            
            // Streak
            let streak = userDataService.getStreakDays()
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                Text("\(streak) day streak")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct StatItem: View {
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
        }
        .frame(maxWidth: .infinity)
    }
}

struct RecentWorkoutsCard: View {
    @EnvironmentObject var userDataService: UserDataService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Recent Workouts")
                    .font(.headline)
                    .fontWeight(.semibold)
                Spacer()
                
                NavigationLink(destination: WorkoutHistoryView()) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            
            let recentWorkouts = Array(userDataService.workouts.prefix(3))
            
            if recentWorkouts.isEmpty {
                VStack(spacing: 10) {
                    Image(systemName: "dumbbell")
                        .font(.title)
                        .foregroundColor(.secondary)
                    Text("No workouts yet")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Start your first workout to see your progress here!")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ForEach(recentWorkouts) { workout in
                    WorkoutRowView(workout: workout)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct WorkoutRowView: View {
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
                Text("\(Int(workout.totalCaloriesBurned)) cal")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("+\(workout.xpEarned) XP")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding(.vertical, 8)
    }
}

struct QuickActionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 15) {
                NavigationLink(destination: WorkoutView()) {
                    QuickActionButton(
                        title: "Start Workout",
                        icon: "play.fill",
                        color: .green
                    )
                }
                
                NavigationLink(destination: ExerciseLibraryView()) {
                    QuickActionButton(
                        title: "Browse Exercises",
                        icon: "list.bullet",
                        color: .blue
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color)
        .cornerRadius(10)
    }
}

struct WorkoutHistoryView: View {
    @EnvironmentObject var userDataService: UserDataService
    
    var body: some View {
        List(userDataService.workouts.sorted(by: { $0.date > $1.date })) { workout in
            WorkoutRowView(workout: workout)
        }
        .navigationTitle("Workout History")
    }
}

#Preview {
    DashboardView()
        .environmentObject(UserDataService())
} 