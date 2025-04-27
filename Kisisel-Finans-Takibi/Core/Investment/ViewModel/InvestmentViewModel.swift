import Foundation
import FirebaseFirestore
import FirebaseAuth

class InvestmentViewModel: ObservableObject {
    @Published var investments: [Investment] = []
    @Published var totalPortfolioValue: Float = 0.0
    @Published var totalProfitLoss: Float = 0.0
    
    init() {
        fetchInvestments()
    }
    
    func fetchInvestments() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Firestore.firestore().collection("investments")
            .whereField("uid", isEqualTo: uid)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("ERROR: fetch investments. Error: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                self.investments = documents.compactMap({ try? $0.data(as: Investment.self) })
                
                // Toplam portföy değeri ve kar/zarar hesaplama
                self.calculateTotals()
            }
    }
    
    private func calculateTotals() {
        totalPortfolioValue = investments.reduce(0) { $0 + $1.totalValue }
        totalProfitLoss = investments.reduce(0) { $0 + $1.profitLoss }
    }
    
    // Yatırım türüne göre gruplandırma
    func investmentsByType(_ type: InvestmentType) -> [Investment] {
        return investments.filter { $0.type == type.rawValue }
            .sorted { $0.totalValue > $1.totalValue }
    }
    
    // Yeni yatırım ekleme
    func addInvestment(type: InvestmentType, name: String, symbol: String,
                      amount: Float, purchasePrice: Float, currentPrice: Float) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "type": type.rawValue,
            "name": name,
            "symbol": symbol,
            "amount": amount,
            "purchasePrice": purchasePrice,
            "currentPrice": currentPrice,
            "date": Timestamp(date: Date()),
            "uid": uid
        ]
        
        Firestore.firestore().collection("investments").document()
            .setData(data) { error in
                if let error = error {
                    print("ERROR: add investment. Error: \(error.localizedDescription)")
                    return
                }
                
                self.fetchInvestments()
            }
    }
}
