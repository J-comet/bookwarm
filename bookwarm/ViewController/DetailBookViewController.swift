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
    
    let thumbImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    let containerView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .monospacedSystemFont(ofSize: 16, weight: .semibold)
        view.numberOfLines = 0
        return view
    }()
    
    let contentLabel = {
        let view = UILabel()
        view.font = .monospacedSystemFont(ofSize: 14, weight: .light)
        view.textColor = .darkGray
        view.numberOfLines = 0
        return view
    }()
    
    let priceLabel = {
        let view = UILabel()
        view.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
        view.textColor = .link
        return view
    }()
    
    let memoTextView = {
        let view = UITextView()
        view.backgroundColor = .systemGray4
        view.textColor = .black
        view.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        view.isEditable = false
        return view
    }()
    
    lazy var editButton = {
        let view = UIButton()
        var attString = AttributedString("수 정")
        attString.font = .systemFont(ofSize: 14, weight: .bold)
        attString.foregroundColor = .white
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attString
        config.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        config.baseBackgroundColor = .orange
        view.configuration = config
        view.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        view.isHidden = true
        return view
    }()
    
    var data: Book?
    
    var editMode = false
    var isEditComplete = false
    
    var defaultText = ""
    
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
        containerView.addSubview(memoTextView)
        containerView.addSubview(editButton)
        
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
        
        memoTextView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(priceLabel)
            make.height.equalTo(200)
        }
        
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(memoTextView.snp.top).offset(-10)
            make.horizontalEdges.equalTo(priceLabel)
        }
        
        guard let data else { return }
        
        let realmData = getRealmBook(data: data)
        if let realmData {
            
            thumbImageView.backgroundColor = .systemGray5
            
            thumbImageView.image = loadImageToDocument(fileName: "\(realmData._id).jpg")
            
//            if let thumbnail = realmData.optThumbnail {
//                thumbImageView.kf.setImage(with: URL(string: thumbnail))
//            }
            titleLabel.text = realmData.title
            contentLabel.text = realmData.optContents == nil ? "내용이 없습니다" : realmData.optContents
            priceLabel.text =  realmData.optPrice == nil ? "가격 정보 없음" : "가격 \(String(describing: realmData.optPrice))원"
            memoTextView.text = realmData.optMemo == nil ? "-" : realmData.optMemo
            defaultText = memoTextView.text
            self.navigationController?.isToolbarHidden = false
        } else {
            thumbImageView.kf.setImage(with: URL(string: data.thumbnail))
            titleLabel.text = data.title
            contentLabel.text = data.contents.isEmpty ? "내용이 없습니다" : data.contents
            priceLabel.text = "가격 \(data.salePrice)원"
            memoTextView.text = "-"
            defaultText = memoTextView.text
            self.navigationController?.isToolbarHidden = true
        }
        
        configToolbar()
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
    
    @objc func editButtonClicked() {
        print("수정 버튼 클릭")
        RealmManager.shared.update(objectType: SearchBook.self) {
            $0.title == titleLabel.text! && $0.optContents == contentLabel.text!
        } update: {
            $0.optMemo = memoTextView.text
        } complete: { isSuccess in
            if isSuccess {
                self.isEditComplete = true
                self.editToolbarButtonClicked()
            } else {
                print(#function, "error")
            }
        }
    }
    
    @objc func editToolbarButtonClicked() {
        print("툴바 수정 클릭")
        editButton.isHidden = editMode
        editMode.toggle()
        memoTextView.isEditable = editMode
        memoTextView.textColor = editMode ? .blue : .black
        
        if !isEditComplete {
            memoTextView.text = defaultText
        }
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
            navigationController?.isToolbarHidden = false
        } else {
            // 현재 저장되어 있는 책이라면 Realm 에서 Delete 해주기
            deleteRealData(realmData: realmData!)
            navigationController?.isToolbarHidden = true
            
            editMode = false
            editButton.isHidden = true
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
        let currentContents = data.contents.isEmpty ? nil : data.contents
        RealmManager.shared.add(
            obj: SearchBook(
                title: data.title,
                optContents: currentContents,
                optMemo: nil,
                optPrice: data.salePrice
            )) { [weak self] isSuccess in
                if isSuccess {
                    let id = self?.getRealmBook(data: data)?._id
                    if let id, let image = self?.thumbImageView.image {
                        self?.saveImageToDocument(fileName: "\(id).jpg", image: image)
                    }
                    self?.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
                } else {
                    print(#function, "실패")
                }
            }
    }
    
    private func deleteRealData(realmData: SearchBook) {
        RealmManager.shared.delete(obj: realmData) { isSuccess in
            if isSuccess {
                self.navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
                self.memoTextView.text = "-"
            } else {
                print(#function, "실패")
            }
        }
    }
    
    private func configToolbar() {
        var items = [UIBarButtonItem]()
        items.append( UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) )
        items.append( UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editToolbarButtonClicked)) )
        self.toolbarItems = items
    }
}
