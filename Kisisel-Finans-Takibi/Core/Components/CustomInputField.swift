import SwiftUI

struct CustomInputField: View {
    
    let iconName: String
    let placeholderText: String
    var isSecured: Bool? = false
    @Binding var text: String
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color(.darkGray))
                
                if isSecured ?? false {
                    SecureField(placeholderText, text: $text)
                } else {
                    TextField(placeholderText, text: $text)
                        .textInputAutocapitalization(.never)
                }
                
            }
            Divider()
                .background(Color(.darkGray))
        }
    }
}
