//
//  AppDelegate.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/07/31.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let config = Realm.Configuration(schemaVersion: 5) { migration, oldSchemaVersion in
            // 단계적으로 schemaVersion 을 업데이트 해주어야함
            // ex_ 0 -> 1, 1 -> 2
            // 추가,삭제는 자동으로 되지만 수정은 직접 명시해주어야 한다.
            if oldSchemaVersion < 1 { }     // 히스토리 = 실수...바로 1로 올려버림.
            if oldSchemaVersion < 2 { }     // 히스토리 - author 컬럼 추가
            if oldSchemaVersion < 3 { }     // 히스토리 - author 컬럼 제거 및 authors 추가
            if oldSchemaVersion < 4 {
                // 히스토리 - date 컬럼명 수정 -> regDate
                migration.renameProperty(onType: SearchBook.className(), from: "authors", to: "master")
            }

            if oldSchemaVersion < 5 {       // 히스토리 - info 컬럼 추가 : 기존 프로퍼티의 값 활용한 컬럼(title + optContent)
                migration.enumerateObjects(ofType: SearchBook.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }

                    // 디폴트 값 설정이 필요할 때
                    new["info"] = "정보"

                    // 기존 프로퍼티 값을 활용하고 싶을 때
                    new["info"] = "제목 '\(old["title"])', 내용 '\(old["optContents"])', 가격 '\(old["optPrice"])' 입니다"

                }
            }
            
        }
        Realm.Configuration.defaultConfiguration = config
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

