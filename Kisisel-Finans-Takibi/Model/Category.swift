

import Foundation


struct Category: Identifiable, Codable, Hashable {
    
    let id: String
    let name: String
    let icon: String
    let color: String
    var type = CategoryType.expense.rawValue

}
