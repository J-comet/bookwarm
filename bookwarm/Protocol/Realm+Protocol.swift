//
//  Realm+Protocol.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/09/06.
//

import Foundation
import RealmSwift

protocol RealmDataBaseProtocol {
    associatedtype T: Object
    func fetch(objType: T.Type) -> Results<T>
    func fetchFilter(objType: T.Type, _ isIncluded: ((Query<T>) -> Query<Bool>)) -> Results<T>
    func create(_ obj: T)
}
