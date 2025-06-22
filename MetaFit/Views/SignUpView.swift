import SwiftUI
import Clerk

struct SignUpView: View {
  @State private var email = ""
  @State private var password = ""
  @State private var code = ""
  @State private var isVerifying = false

  var body: some View {
    VStack {
      Text("Sign Up").font(.largeTitle).fontWeight(.bold)
      if isVerifying {
        TextField("Code", text: $code)
            .textFieldStyle(.roundedBorder)
        Button("Verify") {
          Task { await verify(code: code) }
        }
        .buttonStyle(.borderedProminent)
      } else {
        TextField("Email", text: $email)
            .textFieldStyle(.roundedBorder)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
        SecureField("Password", text: $password)
            .textFieldStyle(.roundedBorder)
        Button("Continue") {
          Task { await signUp(email: email, password: password) }
        }
        .buttonStyle(.borderedProminent)
      }
    }
    .padding()
  }
}

extension SignUpView {

  func signUp(email: String, password: String) async {
    do {
      let signUp = try await SignUp.create(
        strategy: .standard(emailAddress: email, password: password)
      )

      try await signUp.prepareVerification(strategy: .emailCode)

      isVerifying = true
    } catch {
      dump(error)
    }
  }

  func verify(code: String) async {
    do {
      guard let signUp = Clerk.shared.client?.signUp else {
        isVerifying = false
        return
      }

      try await signUp.attemptVerification(strategy: .emailCode(code: code))
    } catch {
      dump(error)
    }
  }

} 