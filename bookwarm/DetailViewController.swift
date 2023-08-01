//
//  DetailViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/07/31.
//

import UIKit

class DetailViewController: UIViewController {
    
    static let identifier = "DetailViewController"
    
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    var movieTitle = ""
    var movieInfo = ""
    var movieContent = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(closeButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        desingMainImageView()
        designInfoLabel()
        designContentLabel()
        
        title = movieTitle
        infoLabel.text = movieInfo
        contentLabel.text = movieContent
        mainImageView.image = UIImage(named: movieTitle)
    }

    @objc
    func closeButtonClicked(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func desingMainImageView() {
        mainImageView.contentMode = .scaleAspectFill
    }
    
    private func designInfoLabel() {
        infoLabel.textColor = .lightGray
        infoLabel.font = .systemFont(ofSize: 14)
    }
    
    private func designContentLabel() {
        contentLabel.lineBreakMode = .byCharWrapping
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .black
        contentLabel.font = .systemFont(ofSize: 16)
    }
}
