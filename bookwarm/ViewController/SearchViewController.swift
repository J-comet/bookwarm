//
//  SearchViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/07/31.
//

import UIKit

class SearchViewController: UIViewController {
    
    static let identifier = "SearchViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색 화면"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(closeButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
    }

    @objc
    func closeButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}
