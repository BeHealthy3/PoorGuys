//
//  CommunityView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/17.
//

import SwiftUI

import SwiftUI

struct CommunityView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    // action
                }, label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                })
                Button(action: {
                    // action
                }, label: {
                    Image(systemName: "person")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                })
            }
            List {
                PostView()
                PostView()
                PostView()
                PostView()
                PostView()
                PostView()
                PostView()
                PostView()
                PostView()
                PostView()
            }
        }
    }
}


struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView()
    }
}
