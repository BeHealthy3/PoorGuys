//
//  PostFillingCenterView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/29.
//

import SwiftUI
import PhotosUI
import LoremSwiftum

struct PostFillingCenterView: View {

    @Binding var content: String
//    @Binding var imageURL: String?
    @Binding var selectedImage: UIImage?
    @State private var isShowingImagePicker = false
    @FocusState private var isTextFieldFocused: Bool

    init(content: Binding<String>, image: Binding<UIImage?>) {
        _content = content
//        _imageURL = imageURL
        _selectedImage = image
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            ZStack {
                if content.isEmpty {
                    VStack {
                        HStack {
                            Text("내용을 입력하세요.")
                                .foregroundColor(.appColor(.neutral600))
                                .padding(.all, 16)
                                .font(.system(size: 16))
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
                if #available(iOS 16.0, *) {
                    TextEditor(text: $content)
                        .font(.system(size: 16))
                        .padding(.all, 10)
                        .frame(maxWidth: .infinity, minHeight: 300)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10.0)
                        .scrollContentBackground(.hidden)
                        
                } else {
                    TextEditor(text: $content)
                        .font(.system(size: 16))
                        .padding(.all, 11)
                        .frame(maxWidth: .infinity, minHeight: 300)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(10.0)
                }
            }
            
            //            if imageURL != nil || image != nil {
            //
            //            }
            if let selectedImage = selectedImage {
                HStack {
                    
                    ZStack {
                        //                    if let imageURL = imageURL,
                        //                       let url = URL(string: imageURL) {
                        //
                        //                        AsyncImage(url: url) { image in
                        //                            image
                        //                                .resizable()
                        //                                .frame(width: 100, height: 100)
                        //                                .cornerRadius(12)
                        //                        } placeholder: {
                        //                            ProgressView()
                        //                        }
                        //                    } else {
                        //                        if let selectedImage = selectedImage {
                        //                            Image(uiImage: selectedImage)
                        //                                .resizable()
                        //                                .frame(width: 100, height: 100)
                        //                                .cornerRadius(12)
                        //                        }
                        //                    }
                        Image(uiImage: selectedImage)
                            .resizable()
                        //                            .frame(width: 100, height: 100)
                            .cornerRadius(12)
                        
                        HStack {
                            Spacer()
                            VStack {
                                Button {
                                    self.selectedImage = nil
                                } label: {
                                    Image("xmarkButtonFill")
                                }
                                .padding(.all, 4)
                                Spacer()
                            }
                        }
                    }
                    .frame(width: 100, height: 100)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            
            HStack {
                Spacer()
                Button {
                    isShowingImagePicker = true
                } label: {
                    Image("addPhotoButton")
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePickerView(selectedImage: $selectedImage)
                        }
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16))
            }
        }
        .background(Color.appColor(.neutral050))
        .cornerRadius(12)
    }
}

struct PostFillingCenterView_Previews: PreviewProvider {
    static var previews: some View {
        PostFillingCenterView(content: .constant(""), image: .constant(nil))
    }
}
