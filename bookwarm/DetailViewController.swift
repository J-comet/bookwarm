//
//  DetailViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/07/31.
//

import UIKit

class DetailViewController: UIViewController {
    
    static let identifier = "DetailViewController"
    
    @IBOutlet var topRoundView: UIView!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    
    var movieData = Movie(title: "", releaseDate: "", runtime: 0, overview: "", rate: 0, isLike: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(closeButtonClicked)
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        
        let likeButtonImage = movieData.isLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: likeButtonImage,
            style: .plain,
            target: self,
            action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .systemPink
        
        designTopRoundView()
        desingMainImageView()
        designInfoLabel(outlet: runtimeLabel)
        designInfoLabel(outlet: dateLabel)
        designInfoLabel(outlet: rateLabel)
        designContentLabel()
        
        title = movieData.title
        contentLabel.text = movieData.overview
        mainImageView.image = UIImage(named: movieData.title)
        runtimeLabel.text = movieData.runtimeByHour
        dateLabel.text = "개봉일: " + movieData.releaseDate
        rateLabel.text = "평점: \(movieData.rate)"
    }

    @objc
    func closeButtonClicked(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func designTopRoundView() {
        topRoundView.layer.cornerRadius = 16
        topRoundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func desingMainImageView() {
        mainImageView.contentMode = .scaleAspectFill
    }
    
    private func designInfoLabel(outlet label: UILabel) {
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12)
    }
    
    private func designContentLabel() {
        contentLabel.lineBreakMode = .byCharWrapping
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .black
        contentLabel.font = .systemFont(ofSize: 16)
    }
}
