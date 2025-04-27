
// Profile complete
import SwiftUI

struct ProfileRowView: View {
    
    let viewModel: RowViewModel

    var body: some View {
        
        HStack(spacing: 16) {
            Image(systemName: viewModel.iconName)
                .font(.headline)
                .foregroundStyle(Color(.gray))
            
            Text(viewModel.title)
                .font(.subheadline)
                .foregroundStyle(Color(.black))
            
            Spacer()
        }
        .frame(height: 40)
        .padding(.horizontal)
    }
}

//#Preview {
//    ProfileRowView()
//}
