
// homepage complete

import Foundation
import Firebase
import FirebaseAuth

final class HomeViewModel: ObservableObject {
    
    @Published var expenses = [ExpenseItem]()
    @Published var incomes = [IncomeItem]()
    
    @Published var totalExpense: Float = 0.0
    @Published var totalIncome: Float = 0.0
    @Published var averageExpense: Float = 0.0
    @Published var averageIncome: Float = 0.0
    
    let service = TransactionService()
    let user: User
    
    init(user: User) {
        self.user = user
        fetchIncome()
        fetchExpense()
        //
//        sumOfExpense()
//        sumOfIncome()
        //
    }
    
    func fetchExpense() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        service.fetchExpense(forUid: uid) { expenses in
            self.expenses = expenses
            for i in 0 ..< expenses.count {
                self.expenses[i].user = self.user
            }
        }
    }
    
    func fetchIncome() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        service.fetchIncome(forUid: uid) { incomes in
            self.incomes = incomes
            for i in 0 ..< incomes.count {
                self.incomes[i].user = self.user
            }
        }
    }
    
    func sumOfExpense() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.totalExpense = 0.0
        self.averageExpense = 0.0
        service.fetchExpense(forUid: uid) { expenses in
            self.expenses = expenses
            for expense in expenses {
                self.totalExpense += expense.amount
                self.averageExpense = self.totalExpense / Float(expenses.count)
            }
        }
    }
    
    func sumOfIncome() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        self.totalIncome = 0.0
        self.averageIncome = 0.0
        service.fetchIncome(forUid: uid) { incomes in
            self.incomes = incomes
            for income in incomes {
                self.totalIncome += income.amount
                self.averageIncome = self.totalIncome / Float(incomes.count)
            }
        }
    }
}



