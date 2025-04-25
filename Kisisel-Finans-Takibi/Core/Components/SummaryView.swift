//
//  SummaryView.swift
//  Kisisel-Finans-Uygulamasi
//
//  Created by Ejder Dağ on 9.12.2024.
//

import SwiftUI

struct SummaryView: View {
    
    var amount: Float
    let currency: String
    let type: String
    let icon: String
    let iconBG: Color

    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: icon)
                        .foregroundStyle(Color(.green))
                        .frame(width: 30, height: 30)
                        .imageScale(.large)
                        .background(Color(.black))
                    Spacer()
                    Text("₺\(String(format: "%.1f", amount))")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.black))
                }
                
                HStack {
                    Text(type)
                        .foregroundColor(.gray)
                        .textCase(.uppercase)
                        .font(.subheadline)
                        .dynamicTypeSize(.small)
                }
                
                .padding(.top, 5)
            }
            .padding(10)
            .padding(.vertical, 5)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

//#Preview {
//    SummaryView()
//}
