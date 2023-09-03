//
//  Notice.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/09/02.
//

import Foundation
import FirebaseFirestoreSwift

struct Notice: Identifiable, Codable {
    @DocumentID var id: String?
    let timeStamp: Date
    let title: String
    let body: String
}
