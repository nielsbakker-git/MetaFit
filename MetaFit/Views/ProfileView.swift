import SwiftUI
import Clerk

struct ProfileView: View {
    @Environment(Clerk.self) private var clerk
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = clerk.user {
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let email = user.primaryEmailAddress {
                            Text(email.emailAddress)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Sign Out", role: .destructive) {
                            Task {
                                do {
                                    try await clerk.signOut()
                                } catch {
                                    print("Error signing out: \(error.localizedDescription)")
                                }
                            }
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }
                    .padding()
                } else {
                    Text("Not signed in.")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environment(Clerk.shared)
    }
} 