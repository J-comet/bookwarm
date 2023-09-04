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
    
    // 모든 데이터 가져오기
    func all<T: Object>(objectType: T.Type) -> Results<T>? {
        print(realm?.configuration.fileURL)
        return realm?.objects(T.self)
    }
    
    // 필터후에 모든 데이터 가져오기
    func filterAll<T: Object>(objectType: T.Type, _ isIncluded: ((Query<T>) -> Query<Bool>)) -> Results<T>? {
        print(realm?.configuration.fileURL)
        return realm?.objects(T.self).where {
            isIncluded($0)
        }
    }
    
    // 추가
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
    
    // 수정
    func update<T: Object>(
        objectType: T.Type,
        _ isIncluded: ((Query<T>) -> Query<Bool>),
        update: (T) -> Void
    ) {
        print(realm?.configuration.fileURL)
        guard let realm = realm else { return }
        
        let currentItem = realm.objects(T.self).where {
            isIncluded($0)
        }.first
        
        do {
            let _ = try realm.write {
                guard let currentItem else {
                    print("UPDATE 할 아이템이 존재하지않음")
                    return
                }
                update(currentItem)
                print("UPDATE Succeed")
            }
            
        } catch  {
            print(#function, "error")
        }
    }
    
}
