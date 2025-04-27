

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    let user: User?
    
    var body: some View {
        
        if let user = authViewModel.currentUser {
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .leading) {
                    Circle()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(Color(.systemBlue))
                    
                    Text(user.fullname)
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("\(user.email)")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundStyle(Color(.systemGray))
                    
                    Divider()
                }
                .padding()
                
                ForEach(RowViewModel.allCases, id: \.rawValue) { rowViewModel in
                    
                    if rowViewModel == .add {
                        NavigationLink {
                            AddView()
                        } label: {
                            ProfileRowView(viewModel: rowViewModel)
                        }
                    } else if rowViewModel == .logout {
                        Button {
                            authViewModel.signOut()
                            dismiss()
                        } label: {
                            ProfileRowView(viewModel: rowViewModel)
                        }
                    } else {
                        ProfileRowView(viewModel: rowViewModel)
                    }
                }
            }
            Spacer()
        }
    }
}

//#Preview {
//    ProfileView()
//}
