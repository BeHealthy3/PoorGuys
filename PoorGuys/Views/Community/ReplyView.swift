//
//  ReplyView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/28.
//

import SwiftUI

//struct ReplyView: View {
//    
//    @State var showingSheet = false
//    
//    let reply: Reply
//    
//    var body: some View {
//        if reply.isDeletedReply {
//            HStack {
//                Text("삭제된 댓글입니다.")
//                    .foregroundColor(.appColor(.neutral600))
//                    .font(.system(size: 14))
//                Spacer()
//            }
//            .padding(EdgeInsets(top: 14, leading: 51, bottom: 14, trailing: 16))
//            
//        } else {
//            LazyVStack(spacing: 4) {
//                HStack(spacing: 8) {
//                    AsyncImage(url: URL(string: reply.profileImageURL ?? "")) { image in
//                        image.resizable()
//                            .frame(width: 24, height: 24)
//                            .clipShape(Circle())
//                        
//                    } placeholder: {
//                        ProgressView()
//                            .frame(width: 24, height: 24)
//                    }
//
//                    Text(reply.nickName)
//                        .lineLimit(1)
//                        .foregroundColor(.appColor(.neutral700))
//                        .font(.system(size: 12, weight: .bold
//                                     ))
//                    Spacer()
//                    Image("verticalEllipsis")
//                        .onTapGesture {
//                            showingSheet = true
//                        }
//                        .confirmationDialog("", isPresented: $showingSheet) {
//                            Button {
//                                print("수정하기")
//                            } label: {
//                                Text("수정하기")
//                            }
//                            Button {
//                                print("신고하기")
//                            } label: {
//                                Text("신고하기")
//                            }
//                        }
//                }
//                
//                HStack {
//                    Text(reply.content)
//                        .foregroundColor(.appColor(.neutral900))
//                        .multilineTextAlignment(.leading)
//                        .font(.system(size: 14))
//                    Spacer()
//                }
//                
//                HStack() {
//                    Text(DateFormatter().excludeYear(from: reply.timeStamp))
//                    Spacer()
//                    HStack(spacing: 4) {
//                        Image("thumbsUp")
//                            .renderingMode(.template)
//                            .foregroundColor(.appColor(.neutral500))
//                        Text(String(reply.likeCount))
//                            .foregroundColor(.appColor(.neutral500))
//                            .font(.system(size: 11))
//                    }
//                    .onTapGesture {
//                        print("좋아요")
//                    }
//                }
//                .font(.system(size: 11))
//                .foregroundColor(.gray)
//            }
//            .padding(EdgeInsets(top: 8, leading: 51, bottom: 8, trailing: 16))
//        }
//    }
//}
//
//struct ReplyView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReplyView(reply: Reply.dummy())
//    }
//}
