//
//  CustomTabBarView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/14.
//

import SwiftUI
import UIKit

enum TabBarItem: Hashable {
    case community, saveHistory, myPage
    
    var defaultIconName: String {
        switch self {
        case .community: return "tabbar.community.default"
        case .saveHistory: return "tabbar.savehistory.default"
        case .myPage: return "tabbar.mypage.default"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .community: return "tabbar.community.selected"
        case .saveHistory: return "tabbar.savehistory.selected"
        case .myPage: return "tabbar.mypage.selected"
        }
    }
}

struct CustomTabBarView: View {
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Binding var isHidden: Bool
    @State var localSelection: TabBarItem
    
    var body: some View {
        tabbar
            .onlyIf(!isHidden)
            .transition(.bottomToTop)
            .onChange(of: selection) { newValue in
                withAnimation(.easeInOut) {
                    localSelection = newValue
                }
            }
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarView(tabs: [.community, .saveHistory, .myPage], selection: .constant(.saveHistory), isHidden: .constant(false), localSelection: .saveHistory)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

extension CustomTabBarView {
    private func switchToTab(tab: TabBarItem) {
        withAnimation(.easeInOut) {
            selection = tab
        }
    }
    
    private func tabView(tab: TabBarItem) -> some View {
        Image(selection == tab ? tab.selectedIconName : tab.defaultIconName)
    }
    
    private var tabbar: some View {
        HStack(spacing: 8) {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 64)
        .if(UIDevice.current.hasNotch) { view in
            view
                .padding(.bottom, 40)
        }
        .if(!UIDevice.current.hasNotch) { view in
            view
                .padding(.bottom, 20)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("white"))
                .shadow(color: Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)), radius: 10)
        }
    }
}
