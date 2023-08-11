//
//  SaveHistoryCardView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/08/09.
//

import SwiftUI

struct SaveHistoryCardView<ViewModel: SaveHistoryViewModelProtocol>: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            HStack {
                Spacer(minLength: 40)
                Text(viewModel.encouragingWords)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color.appColor(.neutral900))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Spacer(minLength: 40)
            }
            
            
            AsyncImage(url: URL(string: viewModel.encouragingImageURL)) { phase in
                
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                    
                @unknown default:
                    Color.appColor(.white)
                        .scaledToFit()
                }
            }
            
            Text(viewModel.total >= 0 ? "+" + viewModel.total.formatToCurrency() : viewModel.total.formatToCurrency())
                .font(.system(size: 36, weight: .black))
                .if(viewModel.total == 0) { view in
                    view
                        .foregroundColor(.appColor(.neutral700))
                }
                .if(viewModel.total > 0) { view in
                    view
                        .foregroundColor(.appColor(.primary500))
                }
                .if(viewModel.total < 0) { view in
                    view
                        .foregroundColor(.appColor(.red))
                }
                .padding(.bottom, 25)
        }
    }
}
