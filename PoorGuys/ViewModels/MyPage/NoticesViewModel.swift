//
//  NoticesViewModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/09/02.
//

import Foundation
import FirebaseFirestore

final class NoticeViewModel: ObservableObject {
    @Published var notices = [Notice]()
    
    func fetchNotices() async throws {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("notices").order(by: "timeStamp", descending: true).getDocuments()
        var newNotices = [Notice]()
        for document in snapshot.documents {
            let noticeID = document.documentID
            let notice = try await fetchNotice(noticeID: noticeID)
            newNotices.append(notice)
        }
        
        DispatchQueue.main.async {
            self.notices = newNotices
        }
    }
    
    func removeNotices() {
        self.notices = []
    }
    
    private func fetchNotice(noticeID: String) async throws -> Notice {
        let db = Firestore.firestore()
        let documentSnapshot = try await db.collection("notices").document(noticeID).getDocument()
        guard let notice = try? documentSnapshot.data(as: Notice.self), documentSnapshot.exists else { throw FirebaseError.documentNotFound }
        
        return notice
    }
}
