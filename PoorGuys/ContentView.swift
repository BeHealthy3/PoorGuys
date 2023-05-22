//
//  ContentView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let viewModel = MockCommunityViewModel()
        CommunityView(viewModel: viewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
