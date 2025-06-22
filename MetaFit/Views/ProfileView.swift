import SwiftUI
import Clerk

struct ProfileView: View {
    @EnvironmentObject var clerk: Clerk
    
    var body: some View {
        NavigationView {
            VStack {
                if let user = clerk.user {
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.gray)
                        
                        Text(user.fullName ?? "No Name")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        if let email = user.primaryEmailAddress {
                            Text(email.emailAddress)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Button("Sign Out", role: .destructive) {
                            clerk.signOut()
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
            .environmentObject(Clerk.shared)
    }
} 