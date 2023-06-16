//
//  PostManager.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

struct FirebasePostManager: PostManagable {
    private let postCollection = Firestore.firestore().collection("posts")
    private let storageReference = Storage.storage().reference()
    
    private var lastDocument: DocumentSnapshot?
    
    func uploadImage(_ image: UIImage) async throws -> URL {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw FirebaseError.imageNotConvertable
        }
        
        let fileName = UUID().uuidString
        let imageRef = storageReference.child("post_images/\(fileName).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let _ = try await imageRef.putDataAsync(imageData, metadata: metadata)
        let url = try await imageRef.downloadURL()
        
        return url
    }
    
    func removeImage(imageID: String) async throws {
        try await storageReference.child(imageID).delete()
    }
    
    func uploadNewPost(_ post: Post, with image: UIImage?) async throws {
        do {
            var post = post
            
            if let image = image {
                let imageURL = try await uploadImage(image)
                post.imageURL = [imageURL.absoluteString]
            }
            
            let ref = try postCollection.addDocument(from: post)
            let refId = ref.documentID
            let data: [String : Any] = [
                Post.codingKeys.id.rawValue : refId
            ]
            
            try await postCollection.document(refId).updateData(data)
        } catch {
            throw error
        }
    }
    
    func updatePost(_ post: Post, with image: UIImage) async throws {
//        postCollection.document(post.id).updateData(<#T##fields: [AnyHashable : Any]##[AnyHashable : Any]#>)
    }
    
    mutating func fetch10Posts() async throws -> [Post] {
        var query = postCollection
               .order(by: "timeStamp", descending: true)
               .limit(to: 10)
        
        if let lastDocument = lastDocument {
            query = query.start(afterDocument: lastDocument)
        }
        
        let querySnapshot = try await query.getDocuments()
        
        let documents = querySnapshot.documents
        var posts: [Post] = []
        
        for document in documents {
            if let post = try? document.data(as: Post.self) {
                posts.append(post)
            }
        }
        
        lastDocument = querySnapshot.documents.last

        return posts
    }
    
    func fetchPost(postID: String) async throws -> Post {
        
        let documentSnapShot = try await postCollection.document(postID).getDocument()
        guard let post = try? documentSnapShot.data(as: Post.self) else { throw FirebaseError.documentNotFound }
        
        return post
    }
    
    func uploadNewComment(_ comment: Comment) throws {}
    
    func deleteComment(commentID: String) async throws {}
    
//    func uploadNewReply(_ reply: Reply) throws {}
//
//    func deleteReply(replyID: String) async throws {}
}

struct MockPostManager: PostManagable {
    
    static let shared = MockPostManager()
    
    private init() {}
    
    func uploadImage(_ image: UIImage) async throws -> URL { return URL(string: "")! }
    func uploadNewPost(_ post: Post, with image: UIImage?) async throws {}
    func updatePost(_ post: Post, with image: UIImage) async throws {}
    
    func fetch10Posts() async throws -> [Post] {
        return await withUnsafeContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                let posts = (0..<10).map { _ in Post.dummy() }
                continuation.resume(returning: posts)
            }
        }
    }
    
    func fetchPost(postID: String) async throws -> Post {
        return await withUnsafeContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                continuation.resume(returning: Post.dummy())
            }
        }
    }
    
    func uploadNewComment(_ comment: Comment) throws {}
    
    func deleteComment(commentID: String) async throws {}
    
//    func uploadNewReply(_ reply: Reply) throws {}
//
//    func deleteReply(replyID: String) async throws {}
}
