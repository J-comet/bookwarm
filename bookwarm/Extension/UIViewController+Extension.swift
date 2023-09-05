//
//  UIViewController+Extension.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/09/05.
//

import UIKit

extension UIViewController {
    
    // 도큐먼트 폴더에 이미지를 로드하는 메서드
    func loadImageToDocument(fileName: String) -> UIImage {
        
        let placeImageView = UIImage(systemName: "star.fill")!
        
        // 1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager.default.urls(
            for: FileManager.SearchPathDirectory.documentDirectory,
            in: .userDomainMask
        ).first else { return placeImageView }
        
        // 2. 저장할 경로 설정(세부 경로, 이미지를 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        // 경로에 이미지가 있는지 확인
        if FileManager.default.fileExists(atPath: fileURL.path) {
            // 파일로 이미지 생성
            return UIImage(contentsOfFile: fileURL.path)!
        } else {
            return placeImageView
        }
    }
    
    // 도큐먼트 폴더에 이미지 저장하는 메서드
    func saveImageToDocument(fileName: String, image: UIImage) {
        
        /**
         TODO: 유저 디바이스의 남은 저장 공간도 체크 해야 하는 코드 추가 필요!!
         */
        
        // 1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager.default.urls(
            for: FileManager.SearchPathDirectory.documentDirectory,
            in: .userDomainMask
        ).first else { return }
        
        // 2. 저장할 경로 설정(세부 경로, 이미지를 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        // 3. 이미지 변환
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        // 4. 이미지 저장
        do {
            // 파일 관련 기능 사용할 때 try 구문 사용 필수
            try data.write(to: fileURL)
            print("이미지파일 저장 완료")
        } catch let error {
            print("file save error", error)
        }
    }
    
    // 도큐멘트 파일 삭제
    func removeImageFromDocument(fileName: String) {
        // 1. 도큐먼트 경로 찾기
        guard let documentDirectory = FileManager.default.urls(
            for: FileManager.SearchPathDirectory.documentDirectory,
            in: .userDomainMask
        ).first else { return }
        
        // 2. 저장할 경로 설정(세부 경로, 이미지를 저장할 위치)
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            print(error)
        }
    }
}
