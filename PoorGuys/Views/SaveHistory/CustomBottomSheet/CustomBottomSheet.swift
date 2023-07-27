
//
//  CustomBottomSheet.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/27.
//

import SwiftUI

protocol ViewModelable {}

struct CustomBottomSheet<Content: View>: View {
    var content: Content

    var body: some View {
        VStack(spacing: 0) {
            content
                .frame(height: 500)
                .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .zIndex(10)
    }
}

struct CustomBottomSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomBottomSheet(content: AddSaveHistoryView<MockSaveHistoryViewModel>())
    }
}

