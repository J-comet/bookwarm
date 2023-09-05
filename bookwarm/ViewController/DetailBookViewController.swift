//
//  DetailBookViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/09/05.
//

import UIKit
import SnapKit
import RealmSwift

class DetailBookViewController: UIViewController {
    
    var thumbImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var containerView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    var titleLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .monospacedSystemFont(ofSize: 16, weight: .semibold)
        view.numberOfLines = 0
        return view
    }()
    
    var contentLabel = {
        let view = UILabel()
        view.font = .monospacedSystemFont(ofSize: 14, weight: .light)
        view.textColor = .darkGray
        view.numberOfLines = 0
        return view
    }()
    
    var priceLabel = {
        let view = UILabel()
        view.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        view.textColor = .link
        return view
    }()
    
    var data: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNav()
        
        print("data = ", data)
        
        containerView.backgroundColor = .systemGray6
        
        view.addSubview(thumbImageView)
        view.addSubview(containerView)
        containerView.addSubview(priceLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        
        thumbImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        
        containerView.snp.makeConstraints { make in
            print(thumbImageView.frame.size.height)
            make.top.equalTo(thumbImageView.snp.bottom).offset(-100)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(priceLabel)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(priceLabel)
        }
        
        
        
        guard let data else { return }
        thumbImageView.kf.setImage(with: URL(string: data.thumbnail))
        titleLabel.text = data.title
        contentLabel.text = data.contents.isEmpty ? "내용이 없습니다" : data.contents
        priceLabel.text = "가격 \(data.salePrice)원"
    }
    
    private func configNav() {
        title = "상세 페이지"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeButtonClicked)
        )
        
        var likeImg = UIImage(systemName: "heart")
        if let data {
            likeImg = getRealmBook(data: data) == nil ? UIImage(systemName: "heart") : UIImage(systemName: "heart.fill")
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: likeImg,
            style: .plain,
            target: self,
            action: #selector(likeButtonClicked)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    @objc func closeButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc func likeButtonClicked() {
        print("좋아요")
        // 추가 메서드
        guard let data else { return }

        let realmData = getRealmBook(data: data)
        if realmData == nil {
            // 저장되어 있지 않다면 Realm 에서 Add 해주기
            addRealmData(data: data)
        } else {
            // 현재 저장되어 있는 책이라면 Realm 에서 Delete 해주기
            deleteRealData(realmData: realmData!)
        }
    }
    
    // 저장되어 있는 realm 데이터 가져오는 함수
    private func getRealmBook(data: Book) -> SearchBook? {
        let currentContents = data.contents.isEmpty ? nil : data.contents
        return RealmManager.shared.filterAll(objectType: SearchBook.self) {
            $0.title == data.title && $0.optContents == currentContents
        }?.first
    }
    
    private func addRealmData(data: Book) {
        RealmManager.shared.add(
            obj: SearchBook(
                title: data.title,
                optContents: data.contents,
                optThumbnail: data.thumbnail
            )) { isSuccess in
                if isSuccess {
                    self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
                } else {
                    print(#function, "실패")
                }
            }
    }
    
    private func deleteRealData(realmData: SearchBook) {
        RealmManager.shared.delete(obj: realmData) { isSuccess in
            if isSuccess {
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            } else {
                print(#function, "실패")
            }
        }
    }
}
