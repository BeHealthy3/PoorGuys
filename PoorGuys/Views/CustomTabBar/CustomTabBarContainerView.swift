//
//  CustomTabBarContainerView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/14.
//

import SwiftUI

protocol ContentViews: View {
    var isTabBarHidden: Bool { get set }
}

struct CustomTabBarContainerView<Content: View>: View {
    let content: Content
    @Binding var selection: TabBarItem
    @State private var tabs: [TabBarItem] = [.community, .saveHistory, .alert]
    @Binding private var isHidden: Bool
    
    init(selection: Binding<TabBarItem>, isHidden: Binding<Bool> ,@ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
        self._isHidden = isHidden
    }
    
    var body: some View {
        ZStack() {
            content
            VStack {
                Spacer()
                CustomTabBarView(tabs: tabs, selection: $selection, isHidden: $isHidden, localSelection: selection)
            }
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

struct TabBarItemsPreferenceKey: PreferenceKey {
    static var defaultValue = [TabBarItem]()
    static func reduce(value: inout [TabBarItem], nextValue: () -> [TabBarItem]) {
        value += nextValue()
    }
}

struct TabBarItemViewModifier: ViewModifier {
    let tab: TabBarItem
    @Binding var selection: TabBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
    }
}

extension View {
    func tabBarItem(tab: TabBarItem, selection: Binding<TabBarItem>) -> some View {
        self
            .modifier(TabBarItemViewModifier(tab: tab, selection: selection))
    }
}
