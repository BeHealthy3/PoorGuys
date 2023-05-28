//
//  TextEditorView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/29.
//

import SwiftUI

struct TextEditorView: View {
    
    @Binding var text: String
    @Binding var textEditorHeight: CGFloat
    @Binding var backgroundNeedsHighlight: Bool
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        
        ZStack(alignment: .leading) {

            Text(text)
                .lineLimit(7)
                .foregroundColor(.clear)
                .padding(.top, 5.0)
                .padding(.bottom, 7.0)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })
            
            TextEditor(text: $text)
                .frame(height: textEditorHeight)
                .padding(.leading, 10)
                .focused($isTextFieldFocused)
                .foregroundColor(.appColor(.neutral900))
            
            if text == "" && !isTextFieldFocused {
                Text("댓글 쓰기")
                    .padding(.leading, 16)
                    .font(.system(size: 16))
                    .foregroundColor(.appColor(.neutral500))
                    .onTapGesture {
                        isTextFieldFocused = true
                    }
            } else {
                
            }
        }
        .onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
        .onReceive(NotificationCenter.default.publisher(for: .replyTapped)) { _ in
                    isTextFieldFocused = true
                }
        .onChange(of: isTextFieldFocused) { focused in
                    backgroundNeedsHighlight = focused
                }
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
