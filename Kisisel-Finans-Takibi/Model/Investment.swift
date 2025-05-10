import Foundation
import FirebaseFirestore

enum InvestmentType: String, CaseIterable {
    case crypto = "Kripto"
    case forex = "Döviz"
    case stock = "Hisse"
    
    var iconName: String {
        switch self {
        case .crypto: return "bitcoinsign.circle.fill"
        case .forex: return "dollarsign.circle.fill"
        case .stock: return "chart.line.uptrend.xyaxis.circle.fill"
        }
    }
}

struct Investment: Identifiable, Decodable {
    @DocumentID var id: String?
    let type: InvestmentType.RawValue
    let name: String
    let symbol: String
    let amount: Float
    let purchasePrice: Float
    let currentPrice: Float
    let date: Date
    let uid: String
    
    var profitLoss: Float {
        return (currentPrice - purchasePrice) * amount
    }
    
    var profitLossPercentage: Float {
        return ((currentPrice - purchasePrice) / purchasePrice) * 100
    }
    
    var totalValue: Float {
        return currentPrice * amount
    }
}
