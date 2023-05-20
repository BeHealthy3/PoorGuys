//
//  PostView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/17.
//

import SwiftUI

struct PostView: View {

    let imageURL = URL(string: "https://picsum.photos/200/300")!

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Title")
                        .font(.title3)
                    Text("Description")
                        .font(.subheadline)
                }
                Spacer()
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}

class ddfsa {
    func dfd() -> any Equatable {
        return 1
    }
    
    func dfd1() -> some Equatable {
        return 1
    }
    
    func `do`() {
        let dsf = dfd()
        let afqew = dfd1()
    }
}
