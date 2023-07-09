//
//  CustomBottomSheet.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/27.
//

import SwiftUI

struct CustomBottomSheet<Content: View>: View {
    
    @Binding var isPresenting: Bool
    var content: Content
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if (isPresenting) {
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresenting.toggle()
                    }
                VStack(spacing: 0) {
                    Spacer()
                    content
                        .frame(height: 500)
                        .transition(.move(edge: .bottom))
                        .cornerRadius(12)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isPresenting)
        .zIndex(10)
    }
}

struct CustomBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomBottomSheet(isPresenting: .constant(true), content: AddSaveHistoryView(viewModel: SaveHistoryViewModel()))
    }
}

