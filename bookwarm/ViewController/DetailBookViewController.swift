//
//  DetailBookViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/09/05.
//

import UIKit
import SnapKit


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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
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
        
        RealmManager.shared.add(
            obj: SearchBook(
                title: data.title,
                optContents: data.contents,
                optThumbnail: data.thumbnail
            )
        )
    }
}
