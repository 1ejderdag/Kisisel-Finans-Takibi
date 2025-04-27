import SwiftUI

struct InvestmentPortfolioView: View {
    @StateObject private var viewModel = InvestmentViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var selectedType: InvestmentType = .crypto
    @State private var showingAddInvestment = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Portföy Özeti
                    PortfolioSummaryView(totalValue: viewModel.totalPortfolioValue,
                                       profitLoss: viewModel.totalProfitLoss)
                    
                    // Yatırım Türü Seçici
                    Picker("Yatırım Türü", selection: $selectedType) {
                        ForEach(InvestmentType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Seçili türdeki yatırımlar
                    ForEach(viewModel.investmentsByType(selectedType)) { investment in
                        InvestmentCardView(investment: investment)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Yatırım Portföyü")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingAddInvestment.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                    }
                }
            }
            .sheet(isPresented: $showingAddInvestment) {
                AddInvestmentView(viewModel: viewModel)
            }
        }
    }
}

struct PortfolioSummaryView: View {
    let totalValue: Float
    let profitLoss: Float
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Portföy Değeri")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("₺\(String(format: "%.2f", totalValue))")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: profitLoss >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text("₺\(String(format: "%.2f", abs(profitLoss)))")
                        Text("(\(String(format: "%.1f", (profitLoss/totalValue) * 100))%)")
                    }
                    .font(.subheadline)
                    .foregroundStyle(profitLoss >= 0 ? Color.green : Color.red)
                }
                
                Spacer()
                
                Image(systemName: "chart.pie.fill")
                    .font(.title)
                    .foregroundStyle(Color(.systemBlue))
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
    }
}

struct InvestmentCardView: View {
    let investment: Investment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: InvestmentType(rawValue: investment.type)?.iconName ?? "questionmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Color(.systemBlue))
                
                VStack(alignment: .leading) {
                    Text(investment.name)
                        .font(.headline)
                    Text(investment.symbol)
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("₺\(String(format: "%.2f", investment.totalValue))")
                        .font(.headline)
                    
                    HStack {
                        Image(systemName: investment.profitLoss >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text("\(String(format: "%.1f", investment.profitLossPercentage))%")
                    }
                    .font(.caption)
                    .foregroundStyle(investment.profitLoss >= 0 ? Color.green : Color.red)
                }
            }
            
            Divider()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Miktar")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text(String(format: "%.4f", investment.amount))
                        .font(.subheadline)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Alış/Güncel")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text("₺\(String(format: "%.2f", investment.purchasePrice))/₺\(String(format: "%.2f", investment.currentPrice))")
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
    }
}

struct AddInvestmentView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: InvestmentViewModel
    
    @State private var selectedType: InvestmentType = .crypto
    @State private var name = ""
    @State private var symbol = ""
    @State private var amount: Float = 0
    @State private var purchasePrice: Float = 0
    @State private var currentPrice: Float = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Picker("Yatırım Türü", selection: $selectedType) {
                    ForEach(InvestmentType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                
                TextField("İsim", text: $name)
                TextField("Sembol", text: $symbol)
                
                TextField("Miktar", value: $amount, format: .number)
                    .keyboardType(.decimalPad)
                
                TextField("Alış Fiyatı", value: $purchasePrice, format: .number)
                    .keyboardType(.decimalPad)
                
                TextField("Güncel Fiyat", value: $currentPrice, format: .number)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle("Yeni Yatırım")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("İptal") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Ekle") {
                        viewModel.addInvestment(
                            type: selectedType,
                            name: name,
                            symbol: symbol,
                            amount: amount,
                            purchasePrice: purchasePrice,
                            currentPrice: currentPrice
                        )
                        dismiss()
                    }
                    .disabled(name.isEmpty || symbol.isEmpty || amount == 0 || purchasePrice == 0 || currentPrice == 0)
                }
            }
        }
    }
}
