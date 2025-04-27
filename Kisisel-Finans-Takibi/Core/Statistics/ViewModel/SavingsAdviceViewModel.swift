import Foundation

class SavingsAdviceViewModel: ObservableObject {
    @Published var categoryAdvices: [CategoryAdvice] = []
    @Published var totalSavingsPotential: Float = 0.0
    
    let homeViewModel: HomeViewModel
    
    struct CategoryAdvice: Identifiable {
        let id = UUID()
        let category: ExpenseCategories
        let currentMonthAmount: Float
        let previousMonthAmount: Float
        let percentageChange: Float
        let message: String
        let savingsPotential: Float
    }
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        analyzeExpenses()
    }
    
    private func analyzeExpenses() {
        var currentMonthExpenses: [ExpenseCategories: Float] = [:]
        var previousMonthExpenses: [ExpenseCategories: Float] = [:]
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        // Şu anki ay ve önceki ay için tarihleri hesapla
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        for expense in homeViewModel.expenses {
            if let category = ExpenseCategories(rawValue: expense.category) {
                let expenseDate = Date() // Burada gerçek expense tarihini kullanmalısınız
                let expenseMonth = calendar.component(.month, from: expenseDate)
                let expenseYear = calendar.component(.year, from: expenseDate)
                
                if expenseMonth == currentMonth && expenseYear == currentYear {
                    currentMonthExpenses[category, default: 0] += expense.amount
                } else if expenseMonth == (currentMonth - 1) && expenseYear == currentYear {
                    previousMonthExpenses[category, default: 0] += expense.amount
                }
            }
        }
        
        // Her kategori için analiz yap
        for category in ExpenseCategories.allCases {
            let currentAmount = currentMonthExpenses[category] ?? 0
            let previousAmount = previousMonthExpenses[category] ?? 0
            
            if currentAmount > 0 || previousAmount > 0 {
                let percentageChange = previousAmount > 0 ?
                    ((currentAmount - previousAmount) / previousAmount) * 100 : 0
                
                var message = ""
                var savingsPotential: Float = 0
                
                if currentAmount > previousAmount && previousAmount > 0 {
                    message = "\(category.title) harcamalarınız geçen aya göre %\(String(format: "%.1f", abs(percentageChange))) arttı."
                    savingsPotential = currentAmount - previousAmount
                } else if currentAmount < previousAmount {
                    message = "Tebrikler! \(category.title) harcamalarınız geçen aya göre %\(String(format: "%.1f", abs(percentageChange))) azaldı."
                    savingsPotential = 0
                } else if previousAmount == 0 {
                    message = "Bu ay \(category.title) kategorisinde ilk harcamalarınızı yaptınız."
                    savingsPotential = 0
                }
                
                if currentAmount > previousAmount * 1.5 && previousAmount > 0 {
                    message += " Dikkat! Bu kategoride önemli bir artış var."
                }
                
                let advice = CategoryAdvice(
                    category: category,
                    currentMonthAmount: currentAmount,
                    previousMonthAmount: previousAmount,
                    percentageChange: percentageChange,
                    message: message,
                    savingsPotential: savingsPotential
                )
                
                categoryAdvices.append(advice)
                totalSavingsPotential += savingsPotential
            }
        }
        
        // Önerileri tasarruf potansiyeline göre sırala
        categoryAdvices.sort { $0.savingsPotential > $1.savingsPotential }
    }
}
