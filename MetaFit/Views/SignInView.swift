import SwiftUI
import Clerk

struct SignInView: View {
  @State private var email = ""
  @State private var password = ""

  var body: some View {
    VStack {
      Text("Sign In").font(.largeTitle).fontWeight(.bold)
      TextField("Email", text: $email)
        .textFieldStyle(.roundedBorder)
        .keyboardType(.emailAddress)
        .autocapitalization(.none)
      SecureField("Password", text: $password)
        .textFieldStyle(.roundedBorder)
      Button("Continue") {
        Task { await submit(email: email, password: password) }
      }
      .buttonStyle(.borderedProminent)
    }
    .padding()
  }
}

extension SignInView {

  func submit(email: String, password: String) async {
    do {
      try await SignIn.create(
        strategy: .identifier(email, password: password)
      )
    } catch {
      dump(error)
    }
  }

} 