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
    private lazy var fileURL = self.realm.configuration.fileURL
    
    func fetch(objType: SearchBook.Type) -> Results<SearchBook> {
        return realm.objects(objType.self)
    }
    
    func fetchFilter(objType: SearchBook.Type, _ isIncluded: ((Query<T>) -> Query<Bool>)) -> Results<SearchBook> {
        print(fileURL)
        return realm.objects(objType.self).where { isIncluded($0) }
    }
    
    func create(_ item: SearchBook) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(#function, "ERROR")
        }
    }
    
    func update(_ item: SearchBook) {
        do {
            try realm.write {
                realm.create(
                    SearchBook.self,
                    value: item,
                    update: .modified
                )
            }
        } catch {
            print(#function, "error")
        }
    }
    
    func delete(_ item: SearchBook) {
        do {
            let _ = try realm.write {
                realm.delete(item)
                print("DELETE Succeed")
            }            
        } catch  {
            print(#function, "error")
        }
    }
}
