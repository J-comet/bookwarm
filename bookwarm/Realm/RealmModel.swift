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
    @Persisted var optMemo: String?     // optional
    @Persisted var optPrice: Int?     // optional
    
    convenience init(
        title: String,
        optContents: String? = nil,
        optMemo: String? = nil,
        optPrice: Int? = nil
    ) {
        self.init()
        self.title = title
        self.saveDate = Date()
        self.optContents = optContents
        self.optMemo = optMemo
        self.optPrice = optPrice
    }
    
    // copy(), 대응하기 위한 함수 기존 init 으로는 ObjectId 가 새로 생겨서 수정시에 새로운 데이터가 추가되는 오류 대응
    convenience init(
        id: ObjectId,
        title: String,
        saveDate: Date,
        optContents: String? = nil,
        optMemo: String? = nil,
        optPrice: Int? = nil
    ) {
        self.init()
        self._id = id
        self.title = title
        self.saveDate = saveDate
        self.optContents = optContents
        self.optMemo = optMemo
        self.optPrice = optPrice
    }
    
    //TODO: 구조체 복사 -> 모든 구조체에 사용할 수 있도록 프로토콜 or 익스텐션으로 만드는 방법??
    func copy(
        title: String? = nil,
        date: Date? = nil,
        optContents: String? = nil,
        optMemo: String? = nil,
        optPrice: Int? = nil
    ) -> SearchBook {
        return .init(
            id: self._id,
            title: title ?? self.title,
            saveDate: date ?? self.saveDate,
            optContents: optContents ?? self.optContents,
            optMemo: optMemo ?? self.optMemo,
            optPrice: optPrice ?? self.optPrice
        )
    }
}
