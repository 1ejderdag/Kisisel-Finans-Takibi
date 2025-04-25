import Foundation
import FirebaseFirestore
import SwiftUI

class CategoryAdviceViewModel: ObservableObject {
    @Published var advices: [CategoryAdvice] = []
    let homeViewModel: HomeViewModel
    
    struct CategoryAdvice: Identifiable {
        let id = UUID()
        let category: ExpenseCategories
        let totalAmount: Float
        let message: String
        let severity: AdviceSeverity
    }
    
    enum AdviceSeverity {
        case normal
        case warning
        case critical
        
        var color: Color {
            switch self {
            case .normal: return .green
            case .warning: return .orange
            case .critical: return .red
            }
        }
    }
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        analyzeCategories()
    }
    
    private func analyzeCategories() {
        var categoryTotals: [ExpenseCategories: Float] = [:]
        
        // Her kategori için toplam harcamaları hesapla
        for expense in homeViewModel.expenses {
            if let category = ExpenseCategories(rawValue: expense.category) {
                categoryTotals[category, default: 0] += expense.amount
            }
        }
        
        // Her kategori için tavsiyeleri oluştur
        for category in ExpenseCategories.allCases {
            let totalAmount = categoryTotals[category] ?? 0
            var message = ""
            var severity: AdviceSeverity = .normal
            
            switch category {
            case .education:
                if totalAmount > 5000 {
                    message = "Eğitim harcamalarınız bu ay oldukça yüksek. Çevrimiçi eğitim alternatifleri değerlendirilebilir."
                    severity = .critical
                } else if totalAmount > 3000 {
                    message = "Eğitim harcamalarınız orta seviyede. İyi bir yatırım yapıyorsunuz."
                    severity = .warning
                } else {
                    message = "Eğitim harcamalarınız makul seviyede."
                    severity = .normal
                }
                
            case .food:
                if totalAmount > 4000 {
                    message = "Yemek harcamalarınız çok yüksek. Ev yemekleri tercih edilebilir."
                    severity = .critical
                } else if totalAmount > 2500 {
                    message = "Yemek harcamalarınız biraz yüksek. Market alışverişlerine yönelebilirsiniz."
                    severity = .warning
                } else {
                    message = "Yemek harcamalarınız normal seviyede."
                    severity = .normal
                }
                
            case .transport:
                if totalAmount > 3000 {
                    message = "Ulaşım harcamalarınız yüksek. Toplu taşıma alternatifleri değerlendirilebilir."
                    severity = .critical
                } else if totalAmount > 1500 {
                    message = "Ulaşım harcamalarınız orta seviyede."
                    severity = .warning
                } else {
                    message = "Ulaşım harcamalarınız makul seviyede."
                    severity = .normal
                }
                
            case .home:
                if totalAmount > 10000 {
                    message = "Ev harcamalarınız çok yüksek. Tasarruf önlemleri alınabilir."
                    severity = .critical
                } else if totalAmount > 7000 {
                    message = "Ev harcamalarınız biraz yüksek."
                    severity = .warning
                } else {
                    message = "Ev harcamalarınız normal seviyede."
                    severity = .normal
                }
                
            case .health:
                if totalAmount > 2000 {
                    message = "Sağlık harcamalarınız yüksek. Sigorta alternatifleri değerlendirilebilir."
                    severity = .warning
                } else {
                    message = "Sağlık harcamalarınız normal seviyede."
                    severity = .normal
                }
                
            case .leisure:
                if totalAmount > 3000 {
                    message = "Eğlence harcamalarınız yüksek. Bütçe dengesini korumak önemli."
                    severity = .critical
                } else if totalAmount > 1500 {
                    message = "Eğlence harcamalarınız orta seviyede."
                    severity = .warning
                } else {
                    message = "Eğlence harcamalarınız makul seviyede."
                    severity = .normal
                }
                
            case .groceries:
                if totalAmount > 5000 {
                    message = "Market harcamalarınız yüksek. İndirim günlerini takip edebilirsiniz."
                    severity = .critical
                } else if totalAmount > 3000 {
                    message = "Market harcamalarınız orta seviyede."
                    severity = .warning
                } else {
                    message = "Market harcamalarınız normal seviyede."
                    severity = .normal
                }
                
            case .others:
                if totalAmount > 2000 {
                    message = "Diğer harcamalarınız yüksek. Detaylı inceleme yapılabilir."
                    severity = .warning
                } else {
                    message = "Diğer harcamalarınız normal seviyede."
                    severity = .normal
                }
            }
            
            let advice = CategoryAdvice(
                category: category,
                totalAmount: totalAmount,
                message: message,
                severity: severity
            )
            
            advices.append(advice)
        }
        
        // Harcama tutarına göre sırala
        advices.sort { $0.totalAmount > $1.totalAmount }
    }
}
