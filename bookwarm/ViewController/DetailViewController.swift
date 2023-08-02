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
    
    @IBOutlet var movieTextView: UITextView!
    
    var movieData = Movie(title: "", releaseDate: "", runtime: 0, overview: "", rate: 0, isLike: false)
    
    var keyHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
    
    @IBAction func tabGestureTabbed(_ sender: UITapGestureRecognizer) {
        movieTextView.resignFirstResponder()
    }
    
    @objc func closeButtonClicked(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // 키보드 올라올 때
    @objc func keyboardWillShow(_ sender: Notification) {
            let userInfo:NSDictionary = sender.userInfo! as NSDictionary
            let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            keyHeight = keyboardHeight
            self.view.frame.size.height -= keyboardHeight
        }
    
    // 키보드 사라질 때
    @objc func keyboardWillHide(_ sender: Notification) {
          self.view.frame.size.height += keyHeight!
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
