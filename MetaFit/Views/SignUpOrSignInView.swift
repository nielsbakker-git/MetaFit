import SwiftUI

struct SignUpOrSignInView: View {
  @State private var isSignUp = true

  var body: some View {
    ScrollView {
        VStack {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 80))
                .foregroundColor(.accentColor)
                .padding(.bottom, 20)

            if isSignUp {
                SignUpView()
            } else {
                SignInView()
            }
            
            Button {
                isSignUp.toggle()
            } label: {
                if isSignUp {
                    Text("Already have an account? Sign In")
                } else {
                    Text("Don't have an account? Sign Up")
                }
            }
            .padding()
        }
        .padding()
    }
  }
} 