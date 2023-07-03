//
//  CurrencyTextField.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/29.
//

import SwiftUI
import Combine

struct CurrencyTextField: View {
    let title: String
    @Binding var price: String
    @State var priceInKorean = ""
    
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en-US")
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        TextField(title, text: $price)
            .font(.system(size: 22, weight: .bold))
            .keyboardType(.numberPad)
            .onReceive(Just(price)) { newValue in
                // 입력된 금액 3자리마다 ,으로 나눠서 표시해주기
                let filtered = newValue.filter { "0123456789".contains($0) } // , 제거
                if filtered.isEmpty {
                    price = ""
                    priceInKorean = writePriceInKorean(0)
                } else {
                    if filtered.count > 7 || Int(filtered)! > 1_000_000 {
                        price = "1,000,000"
                    } else {
                        price = currencyFormatter.string(from: currencyFormatter.number(from: filtered)!)!
                        priceInKorean = writePriceInKorean(Int(filtered)!)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("white"))
            }
            .overlay {
                VStack {
                    HStack() {
                        Spacer()
                        Text(priceInKorean)
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.top, 8)
                            .padding(.trailing, 6)
                    }
                    Spacer()
                }
            }
    }
}

struct CurrencyTextField_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyTextField(title: "금액을 입력해 주세요", price: .constant(""))
    }
}

extension CurrencyTextField {
    
    private func writePriceInKorean(_ price: Int) -> String {
        if price == 0 {
            return ""
        }
        
        var priceText = " 원"
        var value = price
        
        let prefix: [String] = ["", "일", "이", "삼", "사", "오", "육", "칠", "팔", "구"]
        let suffix: [String] = ["", "십", "백", "천"]
        let suffix2: [String] = ["", "만"]
        
        var index2 = 0
        
        while value > 0 {
            var priceTextTemp = ""
            
            for index in 0 ..< 4 {
                guard value != 0 else { break }
                
                let end = value % 10
                
                if end == 1 && index == 0 && index2 == 0 {
                    priceTextTemp = "일"
                } else if end == 1 {
                    priceTextTemp = suffix[index] + priceTextTemp
                } else if end != 0 {
                    priceTextTemp = prefix[end] + suffix[index] + priceTextTemp
                }
                value = value / 10
            }
            priceText = priceTextTemp + suffix2[index2] + priceText
            index2 += 1
        }
        return priceText
    }
}
