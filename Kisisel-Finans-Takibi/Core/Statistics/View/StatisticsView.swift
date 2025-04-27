import SwiftUI
import Charts

struct StatisticsView: View {
    @ObservedObject var homeViewModel: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectionPicker: CategoryType = .expense
    
    var expensesByCategory: [(category: ExpenseCategories, amount: Float)] {
        var categoryTotals: [ExpenseCategories: Float] = [:]
        
        for expense in homeViewModel.expenses {
            if let categoryEnum = ExpenseCategories(rawValue: expense.category) {
                categoryTotals[categoryEnum, default: 0] += expense.amount
            }
        }
        
        return categoryTotals.map { ($0.key, $0.value) }
            .sorted { $0.amount > $1.amount }
    }
    
    var incomesByCategory: [(category: IncomeCategories, amount: Float)] {
        var categoryTotals: [IncomeCategories: Float] = [:]
        
        for income in homeViewModel.incomes {
            if let categoryEnum = IncomeCategories(rawValue: income.category) {
                categoryTotals[categoryEnum, default: 0] += income.amount
            }
        }
        
        return categoryTotals.map { ($0.key, $0.value) }
            .sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Kategori Analizi")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Segmented Picker
                    Picker("Category type", selection: $selectionPicker) {
                        ForEach(CategoryType.allCases, id: \.self) { type in
                            Text("\(type.localizedName())")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(10)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
                    
                    if selectionPicker == .expense {
                        // Giderler Grafiği
                        if !expensesByCategory.isEmpty {
                            Chart {
                                ForEach(expensesByCategory, id: \.category) { item in
                                    SectorMark(
                                        angle: .value("Tutar", item.amount),
                                        innerRadius: .ratio(0.618),
                                        angularInset: 1.5
                                    )
                                    .cornerRadius(5)
                                    .foregroundStyle(by: .value("Kategori", item.category.title))
                                }
                            }
                            .frame(height: 300)
                            .padding()
                            
                            LazyVStack(alignment: .leading, spacing: 15) {
                                ForEach(expensesByCategory, id: \.category) { item in
                                    HStack() {
                                        Image(systemName: item.category.iconName)
                                            .foregroundStyle(Color(.systemBlue))
                                        
                                        Text(item.category.title)
                                            .font(.subheadline)
                                        
                                        Spacer()
                                        
                                        Text("₺\(String(format: "%.2f", item.amount))")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        } else {
                            Text("Henüz harcama verisi bulunmamaktadır.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .padding()
                        }
                    } else {
                        // Gelirler Grafiği
                        if !incomesByCategory.isEmpty {
                            Chart {
                                ForEach(incomesByCategory, id: \.category) { item in
                                    SectorMark(
                                        angle: .value("Tutar", item.amount),
                                        innerRadius: .ratio(0.618),
                                        angularInset: 1.5
                                    )
                                    .cornerRadius(5)
                                    .foregroundStyle(by: .value("Kategori", item.category.title))
                                }
                            }
                            .frame(height: 300)
                            .padding()
                            
                            LazyVStack(alignment: .leading, spacing: 15) {
                                ForEach(incomesByCategory, id: \.category) { item in
                                    HStack {
                                        Image(systemName: item.category.iconName)
                                            .foregroundStyle(Color(.systemGreen))
                                        
                                        Text(item.category.title)
                                            .font(.subheadline)
                                        
                                        Spacer()
                                        
                                        Text("₺\(String(format: "%.2f", item.amount))")
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        } else {
                            Text("Henüz gelir verisi bulunmamaktadır.")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .padding()
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
}
