
import SwiftUI

struct InputView: View {
    
    @Binding var amount: String
    let title: String
    let placeholder: String
    var isSecureField = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Text(title)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .foregroundStyle(Color(.darkGray))
            
            if isSecureField {
                SecureField(placeholder, text: $amount)
                    .font(.system(size: 14))
                    
            } else {
                TextField(placeholder, text: $amount)
                    .font(.system(size: 14))
                    .textCase(.none)
                    
            }
        }
        .padding()
    }
}

//#Preview {
//    InputView()
//}
