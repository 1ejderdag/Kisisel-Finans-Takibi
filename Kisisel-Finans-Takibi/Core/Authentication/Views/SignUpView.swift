
import SwiftUI

struct SignUpView: View {
    
    @State private var email = ""
    @State private var username = ""
    @State private var fullname = ""
    @State private var password = ""
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            AuthHeaderView(row1: "Get started.", row2: "Create your account")
            
            VStack(spacing: 40) {
                
                CustomInputField(iconName: "envelope", placeholderText: "Email", text: $email)
                CustomInputField(iconName: "person", placeholderText: "Full Name", text: $fullname)
                CustomInputField(iconName: "lock", placeholderText: "Password", isSecured: true, text: $password)
            }
            .padding(32)
            
            Button {
                authViewModel.register(withEmail: email, fullname: fullname, password: password)
                dismiss()
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .frame(width: 350, height: 50)
                    .foregroundStyle(Color(.white))
                    .background(Color(.systemOrange))
                    .clipShape(Capsule())
                    .padding()
            }
            .shadow(color: .gray.opacity(0.5), radius: 10)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                HStack {
                    Text("Already have an account?")
                        .font(.footnote)
                    
                    Text("Sign In")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
                .foregroundStyle(Color(.systemOrange))
            }
            .padding(.bottom, 30)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SignUpView()
}
