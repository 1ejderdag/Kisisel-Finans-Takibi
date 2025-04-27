import SwiftUI

struct SavingsAdviceView: View {
    @StateObject var viewModel: SavingsAdviceViewModel
    @Environment(\.dismiss) var dismiss
    
    init(homeViewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: SavingsAdviceViewModel(homeViewModel: homeViewModel))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if viewModel.totalSavingsPotential > 0 {
                        TotalSavingsPotentialView(total: viewModel.totalSavingsPotential)
                    }
                    
                    Text("Kategori Analizleri")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ForEach(viewModel.categoryAdvices) { advice in
                        CategoryAdviceCardView(advice: advice)
                    }
                }
                .padding(.vertical)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Tasarruf Önerileri")
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
            }
        }
    }
}

struct TotalSavingsPotentialView: View {
    let total: Float
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Toplam Tasarruf Potansiyeli")
                .font(.headline)
            
            HStack {
                Image(systemName: "banknote")
                    .font(.title)
                    .foregroundStyle(Color(.systemGreen))
                
                VStack(alignment: .leading) {
                    Text("₺\(String(format: "%.2f", total))")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Bu ay tasarruf edebileceğiniz miktar")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
    }
}

struct CategoryAdviceCardView: View {
    let advice: SavingsAdviceViewModel.CategoryAdvice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: advice.category.iconName)
                    .font(.title2)
                    .foregroundStyle(advice.percentageChange > 0 ? Color.red : Color.green)
                
                Text(advice.category.title)
                    .font(.headline)
                
                Spacer()
                
                if advice.savingsPotential > 0 {
                    Text("₺\(String(format: "%.2f", advice.savingsPotential))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.red)
                }
            }
            
            Text(advice.message)
                .font(.subheadline)
                .foregroundStyle(.gray)
            
            if advice.savingsPotential > 0 {
                Text("Öneri: Bu kategoride geçen ayki harcama seviyenize dönerseniz ₺\(String(format: "%.2f", advice.savingsPotential)) tasarruf edebilirsiniz.")
                    .font(.caption)
                    .foregroundStyle(.blue)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal)
    }
}
