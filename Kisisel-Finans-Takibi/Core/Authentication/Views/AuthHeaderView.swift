

import SwiftUI

struct AuthHeaderView: View {
    
    let row1: String
    let row2: String
    
    var body: some View {
        // header view
        VStack(alignment: .leading) {
            HStack { Spacer() }
            Text("\(row1)\n\(row2)")
                .font(.largeTitle)
                .fontWeight(.semibold)
        }
        .frame(height: 260)
        .padding(.leading)
        .background(Color(.systemOrange))
        .foregroundStyle(Color(.white))
        .clipShape(RoundedShape(corners: [.bottomRight]))
    }
}

//#Preview {
//    AuthHeaderView()
//}
