//
//  RealmManager.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/09/04.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()
    private init() { }
    
    private let realm = try? Realm()
    
    func all<T: Object>(objectClass: T.Type) -> Results<T>? {
        print(realm?.configuration.fileURL)
        return realm?.objects(T.self)
    }
    
    func add(obj: Object) {
        guard let realm = realm else { return }
        do {
            let _ = try realm.write {
                realm.add(obj)
                print("ADD Succeed")
            }
            
        } catch  {
            print(#function, "error")
        }
    }
}
