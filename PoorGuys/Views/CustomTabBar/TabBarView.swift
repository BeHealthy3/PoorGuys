//
//  TabView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import SwiftUI

struct TabBarView: View {
    @State private var selection: String = "community"
    @State private var tabSelection: TabBarItem = .community
    
    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            CommunityView(viewModel: CommunityViewModel())
                .tabBarItem(tab: .community, selection: $tabSelection)
            
            Text("아낌내역 탭")
                .tabBarItem(tab: .saveHistory, selection: $tabSelection)
            
            Text("알림 탭")
                .tabBarItem(tab: .alert, selection: $tabSelection)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

extension TabBarView {
    private var defaultTabView: some View {
        TabView(selection: $selection) {
            Color.red
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            Color.blue
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorite")
                }
            
            Color.orange
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}
