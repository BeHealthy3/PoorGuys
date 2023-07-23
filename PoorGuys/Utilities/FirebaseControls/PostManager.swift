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
    internal var lastDocument: DocumentSnapshot?
    
    private let user: User?
    
    private let commentsField = "comments"
    
    init(user: User? = nil) {
        self.user = user
    }
    
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
        try await storageReference.child("post_images/\(imageID).jpg").delete()
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
    
    func updatePost(_ post: Post, with image: UIImage?) async throws {
        
        var updatedPost = post
        
        if let image = image {
            updatedPost.imageURL = [try await uploadImage(image).absoluteString]
            
            if let oldImageURL = post.imageURL.first {
                try await removeImage(imageID: oldImageURL)
            }
        }
        
        try await postCollection.document(updatedPost.id).updateData(
            [
                "isAboutMoney" : updatedPost.isAboutMoney,
                "title" : updatedPost.title,
                "body" : updatedPost.body,
                "imageURL" : updatedPost.imageURL
            ]
        )
    }
    
    func removePost(postID: String) async throws {
        try await postCollection.document(postID).delete()
    }
    
    mutating func removeLocalPosts() {
        lastDocument = nil
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
        guard let post = try? documentSnapShot.data(as: Post.self), documentSnapShot.exists else { throw FirebaseError.documentNotFound }
        
        return post
    }
    
    func toggleLike(about postID: ID, handler: @escaping (Result<Bool, Error>) -> Void ) throws {
        
        let postRef = postCollection.document(postID)
        let likedUserIDField = "likedUserIDs"
        guard let user = user else { throw LoginError.noCurrentUser }
        
        Firestore.firestore().runTransaction { (transaction, errorPointer) -> Any? in
            
            var postDocument: DocumentSnapshot
            
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard var postData = postDocument.data() else {
                let error = NSError(domain: "firebase post now found", code: -1, userInfo: [NSLocalizedDescriptionKey: "Post not found"])
                errorPointer?.pointee = error
                return nil
            }
            
            guard var likedUserIDs = postData[likedUserIDField] as? [String] else {
                let error = NSError(domain: "likedUserIDField error", code: -2, userInfo: [NSLocalizedDescriptionKey: "likedUserIDs not found"])
                errorPointer?.pointee = error
                return nil
            }
            
            if likedUserIDs.contains(user.uid) {
                likedUserIDs = likedUserIDs.filter { $0 != user.uid }
            } else {
                likedUserIDs.append(user.uid)
            }
            
            postData[likedUserIDField] = likedUserIDs
            transaction.updateData(postData, forDocument: postRef)
            
            return likedUserIDs
        } completion: { likedUserIDs, error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(true))
            }
        }
    }
    
    func addNewComment(with newComment: Comment, postID: ID, handler: @escaping (Result<Bool, Error>) -> Void) throws {
        let postRef = postCollection.document(postID)
        let commentsField = "comments"
        
        Firestore.firestore().runTransaction { (transaction, errorPointer) -> Any? in
            
            var postDocument: DocumentSnapshot
            
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard var postData = postDocument.data() else {
                let error = NSError(domain: "firebase post now found", code: -1, userInfo: [NSLocalizedDescriptionKey: "Post not found"])
                errorPointer?.pointee = error
                return nil
            }
            
            var commentsData = postData[commentsField] as? [[String : Any]]
            
            commentsData?.append(commentData(from: newComment))
            postData[commentsField] = commentsData
            
            transaction.updateData(postData, forDocument: postRef)
            
            return nil
            
        } completion: { _, error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(true))
            }
        }
    }
    
    func removeComment(id: ID, postID: ID, handler: @escaping (Result<Bool, Error>) -> Void) throws {
        let postRef = postCollection.document(postID)
        let commentsField = "comments"
        
        Firestore.firestore().runTransaction { (transaction, errorPointer) -> Any? in
            
            var postDocument: DocumentSnapshot
            
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard var postData = postDocument.data() else {
                let error = NSError(domain: "firebase post now found", code: -1, userInfo: [NSLocalizedDescriptionKey: "Post not found"])
                errorPointer?.pointee = error
                return nil
            }
            
            var commentsData = postData[commentsField] as? [[String : Any]]
            let commentRemovedCommentsData = commentsData?.map({ commentData -> [String : Any] in
                var modifiedCommentData = commentData
                if commentData["id"] as? ID == id {
                    modifiedCommentData["isDeletedComment"] = true
                }
                return modifiedCommentData
            })
            postData[commentsField] = commentRemovedCommentsData
            
            transaction.updateData(postData, forDocument: postRef)
            
            return nil
            
        } completion: { _, error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(true))
            }
        }
    }
    
    func toggleCommentLike(commentID: ID, postID: ID, handler: @escaping (Result<Bool, Error>) -> Void) throws {
        let postRef = postCollection.document(postID)
        let commentsField = "comments"
        let likedUserIDsField = "likedUserIDs"
        
        Firestore.firestore().runTransaction { (transaction, errorPointer) -> Any? in
            
            var postDocument: DocumentSnapshot
            
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard var postData = postDocument.data() else {
                let error = NSError(domain: "firebase post now found", code: -1, userInfo: [NSLocalizedDescriptionKey: "Post not found"])
                errorPointer?.pointee = error
                return nil
            }
            
            let commentsData = postData[commentsField] as? [[String : Any]]
            var isLiked = false
            
            let updatedCommentsData = commentsData?.map({ commentData -> [String : Any] in
                
                var modifiedCommentData = commentData
                
                if let id = commentData["id"] as? String,
                   let user = user, id == commentID {
                    if var likedUserIDs = commentData[likedUserIDsField] as? [String] {
                        if likedUserIDs.contains(user.uid) {
                            modifiedCommentData[likedUserIDsField] = likedUserIDs.filter { $0 != user.uid }
                        } else {
                            likedUserIDs.append(user.uid)
                            modifiedCommentData[likedUserIDsField] = likedUserIDs
                            isLiked = true
                        }
                    }
                }
                
                return modifiedCommentData
            })
            postData[commentsField] = updatedCommentsData
            
            transaction.updateData(postData, forDocument: postRef)
            
            return isLiked
            
        } completion: { isLiked, error in
            if let error = error {
                handler(.failure(error))
            } else {
                if let isLiked = isLiked as? Bool {
                    handler(.success(isLiked))
                }
            }
        }
    }
    
    func reportPost(id: ID, userID: ID, nickName: String, title: String, body: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        guard let user = user else { return completion(.failure(.unknownError)) }
        let db = Firestore.firestore()
        let reportedPostRef = db.collection("reportedPosts").document(id)
        let reportedUserIDsField = "reportedUserIDs"

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            var reportedPostDocument: DocumentSnapshot
            
            do {
                try reportedPostDocument = transaction.getDocument(reportedPostRef)
            } catch let fetchError as NSError {
                completion(.failure(.serverError))
                return nil
            }
            
            if let reportedPostData = reportedPostDocument.data(),
               var reportedUsers = reportedPostData[reportedUserIDsField] as? [String] {
                
                if reportedUsers.contains(user.uid) {
                    completion(.failure(.alreadyReported))
                    return nil
                } else {
                    reportedUsers.append(userID)
                    transaction.updateData([reportedUserIDsField: reportedUsers], forDocument: reportedPostRef)
                    return true
                }

            } else {
                let data: [String: Any] = [
                    "postID": id,
                    "userID": userID,
                    reportedUserIDsField: [user.uid],
                    "nickName": nickName,
                    "title": title,
                    "body": body
                ]
                transaction.setData(data, forDocument: reportedPostRef)
                return true
            }
        }) { (result, error) in
            if let _ = error {
                completion(.failure(.serverError))
            } else {
                if let isSucceed = result as? Bool, isSucceed {
                    completion(.success(true))
                }
            }
        }
    }
    
    func reportComment(id: ID, userID: ID, nickName: String, content: String, completion: @escaping (Result<Bool, FirebaseError>) -> Void) {
        guard let user = user else { return completion(.failure(.unknownError)) }
        let db = Firestore.firestore()
        let reportedCommentRef = db.collection("reportedComments").document(id)
        let reportedUserIDsField = "reportedUserIDs"
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            var reportedPostDocument: DocumentSnapshot
            
            do {
                try reportedPostDocument = transaction.getDocument(reportedCommentRef)
            } catch let fetchError as NSError {
                completion(.failure(.serverError))
                return nil
            }
            
            if let reportedPostData = reportedPostDocument.data(),
               var reportedUsers = reportedPostData[reportedUserIDsField] as? [String] {
                
                if reportedUsers.contains(user.uid) {
                    completion(.failure(.alreadyReported))
                    return nil
                } else {
                    reportedUsers.append(user.uid)
                    transaction.updateData([reportedUserIDsField: reportedUsers], forDocument: reportedCommentRef)
                    return true
                }
                
            } else {
                let data: [String: Any] = [
                    "commentID": id,
                    "userID": userID,
                    reportedUserIDsField: [user.uid],
                    "nickName": nickName,
                    "content" : content
                ]
                transaction.setData(data, forDocument: reportedCommentRef)
                return true
            }
        }) { (result, error) in
            if let _ = error {
                completion(.failure(.serverError))
            } else {
                if let isSucceed = result as? Bool, isSucceed {
                    completion(.success(true))
                }
            }
        }
    }
    
    private func comments(from commentsArray: [[String : Any]]) -> [Comment] {
        var comments: [Comment] = []
        
        for comment in commentsArray {
            guard let id = comment["id"] as? String,
                  let nickName = comment["nickName"] as? String,
                  let profileImageURL = comment["profileImageURL"] as? String?,
                  let userID = comment["userID"] as? String,
                  let postID = comment["postID"] as? String,
                  let content = comment["content"] as? String,
                  let isDeletedComment = comment["isDeletedComment"] as? Bool,
                  let belongingCommentID = comment["belongingCommentID"] as? String?,
                  let likedUserIDs = comment["likedUserIDs"] as? [String],
                  let timeStamp = (comment["timeStamp"] as? Timestamp)?.dateValue() else {
                continue // 하나라도 옵셔널 바인딩이 실패하면 다음 반복으로 넘어감
            }
            
            let commentObject = Comment(id: id, nickName: nickName, profileImageURL: profileImageURL, userID: userID, postID: postID, content: content, likedUserIDs: likedUserIDs, timeStamp: timeStamp, isDeletedComment: isDeletedComment, belongingCommentID: belongingCommentID)
            comments.append(commentObject)
        }
        return comments
    }
    
    private func commentData(from comment: Comment) -> [String : Any] {
        return [
            "id": comment.id,
            "nickName": comment.nickName,
            "profileImageURL": comment.profileImageURL,
            "userID": comment.userID,
            "postID": comment.postID,
            "content": comment.content,
            "timeStamp": comment.timeStamp,
            "isDeletedComment": comment.isDeletedComment,
            "belongingCommentID": comment.belongingCommentID,
            "likedUserIDs": comment.likedUserIDs
        ]
    }
}

struct MockPostManager: PostManagable {
    
    func updateComments(with updatedPost: Post) async throws {
        
    }
    
    func updateCommentsAndCommentsCount(with updatedPost: Post) async throws {}
    
    static let shared = MockPostManager()
    
    private init() {}
    
    func uploadNewPost(_ post: Post, with image: UIImage?) async throws {}
    func updatePost(_ post: Post, with image: UIImage?) async throws {}
    func fetchPost(postID: String) async throws -> Post {
        return await withUnsafeContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                continuation.resume(returning: Post.dummy())
            }
        }
    }
    func removePost(postID: String) async throws {}
    mutating func removeLocalPosts() {}
    func fetch10Posts() async throws -> [Post] {
        return await withUnsafeContinuation { continuation in
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) {
                let posts = (0..<10).map { _ in Post.dummy() }
                continuation.resume(returning: posts)
            }
        }
    }
    func removeComment(id: ID, postID: ID, handler: @escaping (Result<Bool, Error>) -> Void) throws {}
    func toggleCommentLike(commentID: ID, postID: ID, handler: @escaping (Result<Bool, Error>) -> Void) throws {}
    func addNewComment(with newComment: Comment, postID: ID, handler: @escaping (Result<Bool, Error>) -> Void) throws {}
}
