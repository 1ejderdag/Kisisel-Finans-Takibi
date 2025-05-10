
import SwiftUI
import FirebaseCore

// test@gmail.com

@main
struct Kisisel_Finans_UygulamasiApp: App {
    
    @StateObject var authViewModel = AuthViewModel()

    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
                
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .environmentObject(authViewModel)
        }
    }
}
