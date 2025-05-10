
import SwiftUI

struct ContentView: View {
    
    @State var profileMenu = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        if authViewModel.userSession == nil {
            // giriş yapmış kullanıcı yok
            LoginView()
        } else {
            // giriş yapmış kullanıcı var
            if let user = authViewModel.currentUser {
                HomeView(user: user)
                    .toolbar(.visible)
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
