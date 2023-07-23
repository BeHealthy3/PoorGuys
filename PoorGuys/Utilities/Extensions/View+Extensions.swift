//
//  View+Extensions.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/31.
//

import SwiftUI

extension View {
    
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func onlyIf(_ condition: Bool) -> Self? {
        if condition {
            return self
        } else {
            return nil
        }
    }
}
