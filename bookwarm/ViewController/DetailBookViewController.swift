//
//  DetailBookViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/09/05.
//

import UIKit

class DetailBookViewController: UIViewController {
    
    var data: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNav()
        
        print("data = ", data)
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
    }
}
