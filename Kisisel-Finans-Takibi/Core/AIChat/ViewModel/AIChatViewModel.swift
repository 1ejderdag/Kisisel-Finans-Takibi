import Foundation

@MainActor
class AIChatViewModel: ObservableObject {
    @Published var advice: String?
    private var currentContext: String = ""
    
    private let homeViewModel: HomeViewModel
    private let aiService: AIAdviceService
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
        self.aiService = AIAdviceService()
    }
    
    func formatMessage(_ message: String) -> String {
        var formattedMessage = message
        
        // ** ve * işaretlerini kaldır
        formattedMessage = formattedMessage.replacingOccurrences(of: "**", with: "")
        formattedMessage = formattedMessage.replacingOccurrences(of: "*", with: "")
        
        // ## işaretlerini kaldır
        formattedMessage = formattedMessage.replacingOccurrences(of: "##", with: "")
        
        // Çizgileri kaldır
        formattedMessage = formattedMessage.replacingOccurrences(of: "|---|---|---|", with: "")
        formattedMessage = formattedMessage.replacingOccurrences(of: "| ", with: "")
        formattedMessage = formattedMessage.replacingOccurrences(of: " |", with: "")
        
        // Fazla boşlukları temizle
        formattedMessage = formattedMessage.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        
        // Satır başındaki ve sonundaki boşlukları temizle
        formattedMessage = formattedMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return formattedMessage
    }
    
    func getAdvice(for option: AdviceOption) async {
        do {
            var prompt = option.prompt
            
            if option == .financialAdvice {
                // Finansal verileri prompta ekle
                let totalIncome = homeViewModel.totalIncome
                let totalExpense = homeViewModel.totalExpense
                
                var expensesByCategory = ""
                var categoryTotals: [String: Float] = [:]
                
                // Kategori bazlı harcamaları hesapla
                for expense in homeViewModel.expenses {
                    categoryTotals[expense.category, default: 0] += expense.amount
                }
                
                // Kategori toplamlarını metne dönüştür
                expensesByCategory = categoryTotals.map { category, amount in
                    "- \(category): ₺\(String(format: "%.2f", amount))"
                }.joined(separator: "\n")
                
                // Placeholder'ları gerçek verilerle değiştir
                prompt = prompt.replacingOccurrences(of: "{totalIncome}", with: String(format: "%.2f", totalIncome))
                prompt = prompt.replacingOccurrences(of: "{totalExpense}", with: String(format: "%.2f", totalExpense))
                prompt = prompt.replacingOccurrences(of: "{expensesByCategory}", with: expensesByCategory)
            }
            
            currentContext = prompt
            advice = try await aiService.getAdvice(prompt: prompt)
        } catch {
            advice = "Üzgünüm, bir hata oluştu: \(error.localizedDescription)"
        }
    }
    
    func sendMessage(_ message: String) async {
        do {
            let prompt = """
            Önceki bağlam:
            \(currentContext)
            
            Önceki yanıt:
            \(advice ?? "")
            
            Kullanıcı sorusu:
            \(message)
            
            Lütfen kullanıcının sorusunu önceki bağlamı dikkate alarak yanıtla. Yanıtını Türkçe ve anlaşılır bir dille ver.
            """
            
            currentContext = prompt
            advice = try await aiService.getAdvice(prompt: prompt)
        } catch {
            advice = "Üzgünüm, bir hata oluştu: \(error.localizedDescription)"
        }
    }
}
