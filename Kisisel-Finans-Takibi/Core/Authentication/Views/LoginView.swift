
import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        
        // parent container
        VStack {
            
            AuthHeaderView(row1: "Hello.", row2: "Welcome to My Wallet")
            
            VStack(spacing: 30) {
                
                CustomInputField(iconName: "envelope", placeholderText: "Email", text: $email)
                
                CustomInputField(iconName: "lock", placeholderText: "Password", isSecured: true, text: $password)
            }
            .padding(.horizontal, 32)
            .padding(.top, 44)
            
            HStack {
                Spacer()
                
                NavigationLink {
                    Text("clicked forgot password")
                } label: {
                    Text("Forgot Password?")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(.systemOrange))
                        .padding(.top)
                        .padding(.trailing, 5)
                }
            }
                
            Button {
                authViewModel.login(withEmail: email, password: password)
            } label: {
                Text("Sign In")
                    .font(.headline)
                    .frame(width: 350, height: 50)
                    .foregroundStyle(Color(.white))
                    .background(Color(.systemOrange))
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10)
            
            Spacer()
            
            NavigationLink {
                SignUpView()
                    .toolbar(.hidden)
            } label: {
                
                HStack {
                    Text("Don't have an account?")
                        .font(.footnote)
                    
                    Text("Sign Up")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
            .padding(.bottom, 30)
            .foregroundStyle(Color(.systemOrange))

        }
        .ignoresSafeArea()
        .toolbar(.hidden) // navigationBarHidden(true)
    }
}

#Preview {
    LoginView()
}
