import SwiftUI

struct HomeView: View {
    
    private let adaptive =
    [
        GridItem(.adaptive(minimum: 150), spacing: 15)
    ]
    
    @State var selectionPicker: CategoryType = .expense
    @State private var showingStatistics = false
    @State private var showingInvestments = false
    @State private var showingAIChat = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var homeViewModel: HomeViewModel
    
    init(user: User) {
        self.homeViewModel = HomeViewModel(user: user)
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: Alignment(horizontal: .trailing, vertical: .bottom)) {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: adaptive, spacing: 15) {
                        
                        SummaryView(amount: homeViewModel.totalExpense, currency: "₺", type: "Total Expense", icon: "equal.circle.fill", iconBG: .blue)
                        SummaryView(amount: homeViewModel.totalIncome, currency: "₺", type: "Total Income", icon: "plusminus.circle.fill", iconBG: .blue)
                        SummaryView(amount: homeViewModel.averageExpense, currency: "₺", type: "Average Expense", icon: "plus.circle.fill", iconBG: .blue)
                        SummaryView(amount: homeViewModel.averageIncome, currency: "₺", type: "Average Income", icon: "minus.circle.fill", iconBG: .blue)
                    }
                    .padding()
                    
                    segmentedPickerView
                    
                    if selectionPicker == .expense {
                        LazyVStack {
                            ForEach(homeViewModel.expenses) { expense in
                                ListViewExpense(expense: expense)
                            }
                        }
                    } else {
                        LazyVStack {
                            ForEach(homeViewModel.incomes) { income in
                                ListViewIncome(income: income)
                            }
                        }
                    }
                    
                }
                
                HStack {
                    VStack(spacing: 5) {
                        NavigationLink {
                            AIChatView(homeViewModel: homeViewModel)
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 45, height: 45)
                                    .foregroundStyle(Color(.blue))
                                Image(systemName: "brain.head.profile")
                                    .foregroundStyle(Color(.white))
                                    .font(.system(size: 22))
                            }
                        }
                        
                        NavigationLink {
                            AddView()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 55, height: 55)
                                    .foregroundStyle(Color(.black))
                                Image(systemName: "plus")
                                    .foregroundStyle(Color(.white))
                                    .font(.system(size: 28))
                            }
                        }
                    }
                }
                .padding(.all, 25)
            }
        }
        .onAppear {
            homeViewModel.fetchExpense()
            homeViewModel.fetchIncome()
            homeViewModel.sumOfIncome()
            homeViewModel.sumOfExpense()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Text("My Wallet")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.black))
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 15) {
                    Button {
                        showingInvestments.toggle()
                    } label: {
                        Image(systemName: "chart.line.uptrend.xyaxis.circle.fill")
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color(.white))
                            .background(Color(.gray))
                            .clipShape(Circle())
                    }
                    
                    Button {
                        showingStatistics.toggle()
                    } label: {
                        Image(systemName: "chart.pie.fill")
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color(.white))
                            .background(Color(.gray))
                            .clipShape(Circle())
                    }
                    
                    NavigationLink {
                        ProfileView(user: authViewModel.currentUser)
                    } label: {
                        Image(systemName: "person")
                            .frame(width: 35, height: 35)
                            .foregroundStyle(Color(.white))
                            .background(Color(.gray))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .sheet(isPresented: $showingStatistics) {
            StatisticsView(homeViewModel: homeViewModel)
        }
        .sheet(isPresented: $showingInvestments) {
            InvestmentPortfolioView()
                .environmentObject(authViewModel)
        }
        .sheet(isPresented: $showingAIChat) {
            AIChatView(homeViewModel: homeViewModel)
        }
    }
}

extension HomeView {
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
}

//#Preview {
//    HomeView()
//}
