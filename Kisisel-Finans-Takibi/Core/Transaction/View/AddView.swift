
// transaction complete
import SwiftUI
import UIKit

struct AddView: View {
    
    @ObservedObject var transactionViewModel = TransactionViewModel()
    @State var selectedCategoryEx: ExpenseCategories?
    @State var selectedCategoryIn: IncomeCategories?

    @State var selectionPicker: CategoryType = .expense
    @State var date: Date = Date()
    @Environment(\.dismiss) var dismiss
    
    @State var amount: Float = 0
    @State var note: String = ""
    
    var gridColumns = [GridItem(.adaptive(minimum: 70))]
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    segmentedPickerView
                    
                    //inputs
                    amountView
                    noteView
                    
                    categoriesView
                    
                    
                    datePickerView
                    
                    buttonsView
                    
                }
                .padding(10)
            }
        }
    }
}

extension AddView {
    
    var categoriesView: some View {
        VStack {
            // Hata verirse buraya scrollview ekle
                LazyVGrid(columns: gridColumns) {
                    if selectionPicker == .expense {
                        ForEach(ExpenseCategories.allCases, id: \.self) { category in
                            Button {
                                selectedCategoryEx = category
                            } label: {
                                VStack {
                                    Image(systemName: category.iconName)
                                        .frame(width: 70, height: 70)
                                        .font(.title)
                                        .clipShape(Circle())
                                        .background(Circle().fill(selectedCategoryEx == category ? Color(.blue) : Color(.blue).opacity(0.55)))
                                        .foregroundStyle(Color(.white))
                
                                    Text(category.title)
                                        .foregroundStyle(Color(.black))
                                }
                            }
                        }
                    } else {
                        ForEach(IncomeCategories.allCases, id: \.self) { category in
                            Button {
                                selectedCategoryIn = category
                            } label: {
                                VStack {
                                    Image(systemName: category.iconName)
                                        .frame(width: 70, height: 70)
                                        .font(.title)
                                        .clipShape(Circle())
                                        .background(Circle().fill(selectedCategoryIn == category ? Color(.blue) : Color(.blue).opacity(0.55)))
                                        .foregroundStyle(Color(.white))
                
                                    Text(category.title)
                                        .foregroundStyle(Color(.black))
                                }
                            }
                        }
                    }
                }
        }
    }
    
    var datePickerView: some View {
        Section {
            HStack {
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
        } header: {
            Text("Select Date")
                .font(.caption).textCase(.uppercase)
                .padding(.leading, 6)
                .padding(.top, 10)
        }
    }
    
    var segmentedPickerView: some View {
        VStack(alignment: .leading) {
            Section() {
                Picker("Category type", selection: $selectionPicker) {
                    ForEach(CategoryType.allCases, id: \.self) { type in
                        Text("\(type.localizedName())")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(10)
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .onChange(of: selectionPicker) {
                    withAnimation() {
                        //
                    }
                }
            }
            .fontWeight(.bold)
        }
    }
    
    var amountView: some View {
        VStack(alignment: .leading) {
            Section("ENTER AMOUNT") {
                TextField("amount", value: $amount, formatter: formatter)
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .font(.caption)
        }
    }
    
    var noteView: some View {
        VStack(alignment: .leading) {
            Section("ENTER NOTE") {
                TextField("Note for expense", text: $note)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .font(.caption)
        }
    }
    
    var buttonsView: some View {
        HStack {
            Button {
                dismiss() // back to the previous view
            } label: {
                Text("CANCEL")
                    .padding()
                    .background(Color(.red))
                    .foregroundStyle(Color(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
            }
            
            Spacer()
            
            Button {
                if selectionPicker == .expense {
                    transactionViewModel.createExpense(amount: amount, note: note, category: selectedCategoryEx ?? ExpenseCategories.others, date: date)
                } else  if selectionPicker == .income {
                    transactionViewModel.createIncome(amount: amount, note: note, category: selectedCategoryIn ?? IncomeCategories.others, date: date)
                } else {
                    print("else")
                }
                dismiss()
                
            } label: {
                Text("SUBMIT")
                    .padding()
                    .background(Color(.blue))
                    .foregroundStyle(Color(.white))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
            }
        }
        .padding(.top, 20)
        .padding(.leading, 30)
        .padding(.trailing, 30)
    }
}

//#Preview {
//    AddView()
//}
