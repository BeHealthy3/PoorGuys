//
//  ExportingSaveHistoryView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/08/10.
//

import SwiftUI

struct ExportingSaveHistoryView<ViewModel: SaveHistoryViewModelProtocol>: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 28) {
            VStack(spacing: 0) {
                SaveHistoryCardView(viewModel: _viewModel)
                    .environmentObject(viewModel)
                    .frame(height: 340)
                    .background {
                        Color.white
                    }
                    
                ZStack {
                    Color.appColor(.primary500)
                    Text(DateFormatter().toKoreanIncludingYear(from: viewModel.date))
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(width: .infinity, height: 55)
            }
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1) , radius: 10)
            
            HStack {
                VStack(spacing: 19) {
                    Button {
                        
                    } label: {
                        RoundButton(imageName: "downloadButton")
                    }
                    
                    Text("저장")
                        .foregroundColor(.appColor(.neutral900))
                        .font(.system(size: 14, weight: .bold))
                }
                .padding(.leading, 43)
                
                Spacer()

                VStack(spacing: 19) {
                    Button {
                        
                    } label: {
                        RoundButton(imageName: "exportButton")
                    }
                    
                    Text("공유")
                        .foregroundColor(.appColor(.neutral900))
                        .font(.system(size: 14, weight: .bold))
                }
                
                Spacer()
                
                VStack(spacing: 19) {
                    Button {
                        
                    } label: {
                        RoundButton(imageName: "inviteButton")
                    }
                    
                    Text("초대")
                        .foregroundColor(.appColor(.neutral900))
                        .font(.system(size: 14, weight: .bold))
                }
                .padding(.trailing, 43)
            }
                
            HStack {
                Spacer()
                Text("취소")
                    .foregroundColor(.appColor(.primary500))
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appColor(.primary500), lineWidth: 1)
            )
            
            Spacer()
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .background(Color.appColor(.white))
        .cornerRadius(12)
        .ignoresSafeArea()
    }
}

struct ExportingSaveHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExportingSaveHistoryView<SaveHistoryViewModel>()
            .environmentObject(SaveHistoryViewModel())
    }
}
