import SwiftUI
import Clerk

struct ContentView: View {
    @StateObject var clerk = Clerk.shared
    
    var body: some View {
        VStack {
            if clerk.user != nil {
                DashboardView()
            } else {
                SignInView()
            }
        }
        .onAppear {
            clerk.load()
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