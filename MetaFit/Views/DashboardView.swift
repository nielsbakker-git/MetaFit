import SwiftUI
import Clerk

struct DashboardView: View {
    @EnvironmentObject var clerk: Clerk
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                if let user = clerk.user {
                    Text("Welcome, \(user.firstName ?? "User")!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Gamification Stats
                    HStack {
                        StatCard(title: "Level", value: "1", icon: "star.fill")
                        StatCard(title: "XP", value: "0", icon: "bolt.fill")
                    }
                    
                    // Quick Actions
                    VStack(alignment: .leading) {
                        Text("Quick Actions").font(.headline)
                        Button("Start New Workout") {
                            // Action for starting a new workout
                        }
                        .buttonStyle(.borderedProminent)
                    }
                } else {
                    Text("Loading user data...")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.accentColor)
            Text(title)
                .font(.headline)
            Text(value)
                .font(.title)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(Clerk.shared)
    }
} 