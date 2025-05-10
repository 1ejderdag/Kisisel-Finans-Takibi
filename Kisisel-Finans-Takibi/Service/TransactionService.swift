

import Foundation
import Firebase

class TransactionService {
    
    func fetchExpense(forUid uid: String, completion: @escaping([ExpenseItem]) -> Void) {
        Firestore.firestore().collection("expenses")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("ERROR: fetch expense.Error: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                let expenses = documents.compactMap({ try? $0.data(as: ExpenseItem.self) })
                completion(expenses)
        }
    }
    
    func fetchIncome(forUid uid: String, completion: @escaping([IncomeItem]) -> Void) {
        Firestore.firestore().collection("incomes")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("ERROR: fetch expense.Error: \(error.localizedDescription)")
                    return
                }
                guard let documents = snapshot?.documents else { return }
                let incomes = documents.compactMap({ try? $0.data(as: IncomeItem.self) })
                completion(incomes)
        }
    }
}
