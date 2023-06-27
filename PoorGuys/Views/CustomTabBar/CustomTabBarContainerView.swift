//
//  CustomTabBarContainerView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/14.
//

import SwiftUI

struct CustomTabBarContainerView<Content: View>: View {
    let content: Content
    @Binding var selection: TabBarItem
    @State private var tabs: [TabBarItem] = [.community, .saveHistory, .alert]
    
    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack() {
            content
            VStack {
                Spacer()
                CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
            }
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    
    static let tabs: [TabBarItem] = [
        .community, .saveHistory, .alert
    ]
    
    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(tabs.first!)) {
            Color(.red)
        }
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
