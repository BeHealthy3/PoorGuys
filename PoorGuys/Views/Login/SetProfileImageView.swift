//
//  SetProfileImageView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI

struct SetProfileImageView: View {
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 200)
            Text("000님이 거지방에서 사용하실 프로필 사진을 등록해 주세요.")
                .lineLimit(2)
                .font(.system(size: 22, weight: .bold))
                .padding(.horizontal)
            Rectangle()
                .frame(width: 200, height: 200)
                .foregroundColor(.gray)
                .padding(.top, 24)
            Spacer()
            VStack {
                skipButton()
                completeButton()
            }
            .padding(.bottom, 40)
        }
    }
    
    @ViewBuilder
    func skipButton() -> some View {
        Button {
            /* TODO : 프로필 사진 업로드 건너뛰기 */
        } label: {
            Text("건너뛰기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.blue)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue, lineWidth: 1)
                }
                .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func completeButton() -> some View {
        Button {
            /* TODO : 첫 로그인 완료 */
        } label: {
            Text("완료")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
        }
    }
}

struct SetProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        SetProfileImageView()
    }
}
