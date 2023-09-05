//
//  RealmModel.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/09/04.
//

import Foundation
import RealmSwift

class SearchBook: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var title: String
    @Persisted var saveDate: Date
    @Persisted var optContents: String?     // optional
    @Persisted var optThumbnail: String?     // optional
    @Persisted var optMemo: String?     // optional
    @Persisted var optPrice: Int?     // optional
    
    convenience init(
        title: String,
        optContents: String? = nil,
        optThumbnail: String? = nil,
        optMemo: String? = nil,
        optPrice: Int? = nil
    ) {
        self.init()
        self.title = title
        self.saveDate = Date()
        self.optContents = optContents
        self.optThumbnail = optThumbnail
        self.optMemo = optMemo
        self.optPrice = optPrice
    }
    
}
