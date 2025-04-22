
// Auth completed

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase

class AuthViewModel: ObservableObject {
    
    @Published public var userSession = Auth.auth().currentUser
    @Published public var didAuthenticateUser = false
    @Published public var currentUser: User?
    let userService = UserService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        self.fetchUser()
//        //
//        if let uid = self.userSession?.uid {
//            print("DEBUG: User session is \(uid)")
//        } else {
//            print("DEBUG: No user session found")
//        }
//        //
        
        print("DEBUG: User session is \(String(describing: self.userSession?.uid))")
    }
    
    func login(withEmail email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to sign in. Error: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            self.fetchUser()
            print("DEBUG: Sign user in successfuly")
            
        }
    }
    
    func register(withEmail email: String, fullname: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("DEBUG: Failed to register. Error: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            self.userSession = user
            print("DEBUG: Register user successfuly")
            
            let data = ["email": email.lowercased(),
                        "fullname": fullname]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data) { error in
                    if let error = error {
                        print("DEBUG: Failed to upload user data. Error:\(error.localizedDescription)")
                        return
                    }
                    print("DEBUG: User data uploaded")
                    self.didAuthenticateUser = true
                    self.fetchUser()
                }
        }
    }
    
    func signOut() {
        
        // Arayüzü login view olur
        self.userSession = nil
        didAuthenticateUser = false
        
        // server'da kullanıcı çıkış yapar
        try? Auth.auth().signOut()
        print("Sign out")
    }
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        
        userService.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
}
