import Foundation
import GoogleGenerativeAI

class AIAdviceService {
    private let model: GenerativeModel
    
    init() {
        let apiKey = "AIzaSyC8_z-SjTQN15r4mp6OO9QyiP-y62SbypU"
        self.model = GenerativeModel(name: "gemini-pro", apiKey: apiKey)
    }
    
    func getAdvice(prompt: String) async throws -> String {
        let response = try await model.generateContent(prompt)
        return response.text ?? "Üzgünüm, şu anda tavsiye oluşturulamıyor."
    }
}
