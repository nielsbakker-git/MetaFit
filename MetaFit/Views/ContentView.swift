import SwiftUI
import Clerk

struct ContentView: View {
    @Environment(Clerk.self) private var clerk

    var body: some View {
        VStack {
            if let user = clerk.user {
                DashboardView()
                Button("Sign Out") {
                    Task { try? await clerk.signOut() }
                }
                .buttonStyle(.bordered)
                .padding()
            } else {
                SignUpOrSignInView()
            }
        }
    }
}

struct SignInView: View {
    @EnvironmentObject var clerk: Clerk
    
    var body: some View {
        VStack(spacing: 20) {
            Text("MetaFit")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Your gamified fitness journey.")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            Button("Sign In or Sign Up") {
                clerk.presentSignIn()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 