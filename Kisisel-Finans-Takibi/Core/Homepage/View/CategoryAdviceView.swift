import SwiftUI

struct CategoryAdviceView: View {
    @StateObject var viewModel: CategoryAdviceViewModel
    @Environment(\.dismiss) var dismiss
    
    init(homeViewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: CategoryAdviceViewModel(homeViewModel: homeViewModel))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.advices) { advice in
                        CategoryAdviceCard(advice: advice)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Kategori Tavsiyeleri")
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

struct CategoryAdviceCard: View {
    let advice: CategoryAdviceViewModel.CategoryAdvice
    
    var statusIcon: some View {
        ZStack {
            Circle()
                .fill(advice.severity.color)
                .frame(width: 24, height: 24)
            
            Image(systemName: severityIcon)
                .font(.system(size: 12))
                .foregroundStyle(.white)
        }
    }
    
    var severityIcon: String {
        switch advice.severity {
        case .normal: return "checkmark"
        case .warning: return "exclamationmark"
        case .critical: return "exclamationmark.triangle.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                HStack {
                    Image(systemName: advice.category.iconName)
                        .font(.title2)
                        .foregroundStyle(.blue)
                    
                    VStack(alignment: .leading) {
                        Text(advice.category.title)
                            .font(.headline)
                        
                        Text("₺\(String(format: "%.2f", advice.totalAmount))")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                }
                .padding(.trailing, 30)
                
                statusIcon
            }
            
            Text(advice.message)
                .font(.subheadline)
                .foregroundStyle(.gray)
                .padding(.top, 5)
            
            // Durum çubuğu
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray6))
                        .frame(height: 4)
                    
                    Rectangle()
                        .fill(advice.severity.color)
                        .frame(width: severityWidth(totalWidth: geometry.size.width), height: 4)
                }
            }
            .frame(height: 4)
            .clipShape(RoundedRectangle(cornerRadius: 2))
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private func severityWidth(totalWidth: CGFloat) -> CGFloat {
        switch advice.severity {
        case .normal: return totalWidth * 0.33
        case .warning: return totalWidth * 0.66
        case .critical: return totalWidth
        }
    }
}
