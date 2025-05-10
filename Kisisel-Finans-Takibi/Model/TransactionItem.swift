
import Foundation
import SwiftUI

class TransactionItem: Identifiable{
    
    var id: String = ""
    var amount: Float = 0
    var note: String = ""
    var date: Date = Date() //default value is current date and time
    var type: CategoryType = .expense
    var category: Category?
    
    
    init(id: String, amount: Float, note: String, date: Date, type: CategoryType, category: Category? = nil) {
        self.id = id
        self.amount = amount
        self.note = note
        self.date = date
        self.type = type
        self.category = category
    }
}
