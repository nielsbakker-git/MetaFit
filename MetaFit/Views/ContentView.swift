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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 