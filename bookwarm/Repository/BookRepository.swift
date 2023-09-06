//
//  Repository.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/09/06.
//

import Foundation
import RealmSwift

class BookRepository: RealmDataBaseProtocol {
    
    typealias T = SearchBook
    private let realm = try! Realm()
    
    func fetch(objType: SearchBook.Type) -> Results<SearchBook> {
        return realm.objects(objType.self)
    }
    
    func fetchFilter(objType: SearchBook.Type, _ isIncluded: ((Query<T>) -> Query<Bool>)) -> Results<SearchBook> {
        return realm.objects(objType.self).where { isIncluded($0) }
    }
    
    func create(_ obj: SearchBook) {
        do {
            try realm.write {
                realm.add(obj)
            }
        } catch {
            print(#function, "ERROR")
        }
    }
    
    
}
