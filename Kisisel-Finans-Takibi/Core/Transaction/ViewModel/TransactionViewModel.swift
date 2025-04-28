import Foundation
import FirebaseFirestore
import FirebaseAuth

final class TransactionViewModel: ObservableObject{
        
    func createExpense(amount: Float, note: String, category: ExpenseCategories, date: Date) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
                
        let data = ["uid": uid,
                    "amount": amount,
                    "note": note,
                    "category": category.rawValue,
                    "date": Timestamp(date: date)] as [String : Any]
        
        Firestore.firestore().collection("expenses").document()
            .setData(data) { error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                print("Expense Created")
            }
    }
    
    func createIncome(amount: Float, note: String, category: IncomeCategories, date: Date) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
                
        let data = ["uid": uid,
                    "amount": amount,
                    "note": note,
                    "category": category.rawValue,
                    "date": Timestamp(date: date)] as [String : Any]
        
        Firestore.firestore().collection("incomes").document()
            .setData(data) { error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
                print("Income Created")
            }
    }
}

