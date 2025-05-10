
import Foundation
import Firebase
import FirebaseFirestore

class UserService {
    
    func fetchUser(withUid uid: String, completion: @escaping(User) -> Void) {

        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else { return }
                
                guard let user = try? snapshot.data(as: User.self) else { return }
            
                print("User email is \(user.email)")
                completion(user)
            }
    }
}
