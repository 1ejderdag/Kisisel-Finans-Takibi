
import Foundation
import FirebaseFirestore
import Firebase

struct User: Identifiable, Decodable {
    @DocumentID var id: String?
    let email: String
    let fullname: String
}
