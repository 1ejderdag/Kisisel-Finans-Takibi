import SwiftUI

struct AIChatView: View {
    @StateObject private var viewModel: AIChatViewModel
    @State private var isLoading = false
    @State private var selectedOption: AdviceOption?
    @State private var userMessage = ""
    @State private var isChatting = false
    
    init(homeViewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: AIChatViewModel(homeViewModel: homeViewModel))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if isLoading {
                    VStack {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Düşünüyorum...")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                } else if isChatting {
                    // Sohbet Modu
                    VStack(spacing: 15) {
                        if let advice = viewModel.advice {
                            ScrollView {
                                ChatBubble(message: viewModel.formatMessage(advice), isFromAI: true)
                            }
                        }
                        
                        // Mesaj Gönderme Alanı
                        HStack(spacing: 12) {
                            TextField("Mesajınızı yazın...", text: $userMessage)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .submitLabel(.send)
                                .onSubmit {
                                    sendMessage()
                                }
                            
                            Button {
                                sendMessage()
                            } label: {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 32))
                                    .foregroundStyle(.blue)
                            }
                            .disabled(userMessage.isEmpty)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                    }
                } else if let advice = viewModel.advice {
                    // Tavsiye Görüntüleme
                    VStack(alignment: .leading, spacing: 15) {
                        // Başlık Alanı
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 45, height: 45)
                                
                                Image(systemName: selectedOption?.icon ?? "brain")
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                            }
                            
                            VStack(alignment: .leading) {
                                Text(selectedOption?.title ?? "Finansal Asistanınız")
                                    .font(.headline)
                                Text("AI Asistan")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .padding(.bottom, 10)
                        
                        // Tavsiye Metni
                        Text(viewModel.formatMessage(advice))
                            .font(.body)
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        
                        // Sohbet Butonu
                        Button {
                            withAnimation {
                                isChatting = true
                            }
                        } label: {
                            HStack {
                                Image(systemName: "message.circle.fill")
                                    .font(.title3)
                                Text("Sohbete Devam Et")
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundStyle(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: .black.opacity(0.05), radius: 10)
                    .padding()
                } else {
                    // Ana Menü
                    VStack(spacing: 25) {
                        // AI İkonu
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "brain.head.profile")
                                .font(.system(size: 40))
                                .foregroundStyle(.blue)
                        }
                        
                        Text("Finansal Asistanınız")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Hangi konuda bilgi almak istersiniz?")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                        
                        // Seçenekler
                        ForEach(AdviceOption.allCases) { option in
                            Button {
                                selectedOption = option
                                Task {
                                    isLoading = true
                                    await viewModel.getAdvice(for: option)
                                    isLoading = false
                                }
                            } label: {
                                MenuOptionCard(option: option)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("AI Finansal Asistan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.advice != nil {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            viewModel.advice = nil
                            selectedOption = nil
                            isChatting = false
                            userMessage = ""
                        }
                    } label: {
                        Image(systemName: "house.circle.fill")
                            .font(.title3)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
    
    private func sendMessage() {
        guard !userMessage.isEmpty else { return }
        
        Task {
            isLoading = true
            await viewModel.sendMessage(userMessage)
            userMessage = ""
            isLoading = false
        }
    }
}

struct ChatBubble: View {
    let message: String
    let isFromAI: Bool
    
    var body: some View {
        HStack {
            if isFromAI {
                // AI İkonu
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: "brain")
                        .font(.system(size: 16))
                        .foregroundStyle(.blue)
                }
                .padding(.trailing, 8)
            }
            
            Text(message)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(isFromAI ? Color(.systemGray6) : Color.blue)
                .foregroundStyle(isFromAI ? Color.primary : Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            if !isFromAI {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

struct MenuOptionCard: View {
    let option: AdviceOption
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: option.icon)
                    .font(.title3)
                    .foregroundStyle(.blue)
            }
            
            Text(option.title)
                .font(.headline)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .foregroundStyle(.primary)
    }
}

enum AdviceOption: String, CaseIterable, Identifiable {
    case financialAdvice = "financial"
    case cryptoNews = "crypto"
    case stockMarket = "stocks"
    case savingTips = "savings"
    case investmentStrategy = "investment"
    
    var id: String { self.rawValue }
    
    var title: String {
        switch self {
        case .financialAdvice: return "Finansal Tavsiye"
        case .cryptoNews: return "Kripto Para Haberleri"
        case .stockMarket: return "Borsa İstanbul Haberleri"
        case .savingTips: return "Tasarruf İpuçları"
        case .investmentStrategy: return "Yatırım Stratejileri"
        }
    }
    
    var icon: String {
        switch self {
        case .financialAdvice: return "chart.pie"
        case .cryptoNews: return "bitcoinsign.circle"
        case .stockMarket: return "chart.line.uptrend.xyaxis"
        case .savingTips: return "banknote"
        case .investmentStrategy: return "arrow.triangle.branch"
        }
    }
    
    var prompt: String {
        switch self {
        case .financialAdvice:
            return """
            Sen bir finansal danışmansın. Aşağıdaki finansal verilere göre kullanıcıya kişiselleştirilmiş tavsiyeler ver:

            Toplam Gelir: ₺{totalIncome}
            Toplam Gider: ₺{totalExpense}
            
            Kategori bazlı harcamalar:
            {expensesByCategory}
            
            Lütfen şunları analiz et:
            1. Gelir-gider dengesi
            2. Kategori bazlı harcama analizi
            3. Tasarruf potansiyeli
            4. Finansal hedefler için öneriler
            
            Yanıtını Türkçe, samimi ve yapıcı bir dille ver. Kullanıcıya özel, uygulanabilir tavsiyeler sun.
            """
            
        case .cryptoNews:
            return """
            Sen bir kripto para uzmanısın. Lütfen aşağıdaki konularda güncel bilgiler ver:

            1. Bitcoin, Ethereum ve diğer önemli kripto paraların son durumu
            2. Kripto para piyasasındaki önemli gelişmeler
            3. Yaklaşan önemli olaylar (hard fork, güncelleme, vb.)
            4. Dikkat edilmesi gereken riskler
            5. Yatırımcılar için öneriler

            Yanıtını Türkçe ve anlaşılır bir dille ver. Teknik terimleri açıkla.
            """
            
        case .stockMarket:
            return """
            Sen bir borsa uzmanısın. Lütfen Borsa İstanbul (BIST) hakkında aşağıdaki bilgileri ver:

            1. BIST 100 endeksinin son durumu ve trend analizi
            2. Öne çıkan sektörler ve hisseler
            3. Piyasayı etkileyen önemli gelişmeler
            4. Ekonomik göstergelerin piyasaya etkisi
            5. Yatırımcılar için dikkat edilmesi gereken noktalar

            Yanıtını Türkçe ve anlaşılır bir dille ver. Teknik terimleri açıkla.
            """
            
        case .savingTips:
            return """
            Sen bir tasarruf uzmanısın. Lütfen aşağıdaki konularda pratik öneriler sun:

            1. Günlük hayatta tasarruf yöntemleri
            2. Fatura ve abonelik giderlerini azaltma taktikleri
            3. Alışveriş yaparken tasarruf ipuçları
            4. Enerji tasarrufu önerileri
            5. Küçük birikimleri değerlendirme yolları

            Yanıtını Türkçe, pratik ve uygulanabilir şekilde ver. Somut örnekler kullan.
            """
            
        case .investmentStrategy:
            return """
            Sen bir yatırım stratejisti ve portföy yöneticisisin. Lütfen şu konularda detaylı bilgi ver:

            1. Farklı yatırım araçlarının karşılaştırması
            2. Risk yönetimi ve portföy çeşitlendirme
            3. Uzun vadeli yatırım stratejileri
            4. Başlangıç seviyesi yatırımcılar için öneriler
            5. Piyasa koşullarına göre yatırım tavsiyeleri

            Yanıtını Türkçe ve anlaşılır bir dille ver. Risk-getiri dengesini vurgula.
            """
        }
    }
}
