//
//  DetailViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/07/31.
//

import UIKit

class DetailViewController: UIViewController {
    
    static let identifier = "DetailViewController"
    static let placeHolderText = "리뷰를 남겨주세요"
    
    @IBOutlet var topRoundView: UIView!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var runtimeLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var movieTextView: UITextView!

    var movieData = Movie(title: "", releaseDate: "", runtime: 0, overview: "", rate: 0, isLike: false)
    
    var keyHeight: CGFloat?
    
//    let moviePlaceHolder = "리뷰를 남겨주세요"
    
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
        
        movieTextView.delegate = self
        movieTextView.text = DetailViewController.placeHolderText
        movieTextView.textColor = .lightGray
        
        countLabel.text = "0 / 10"
    }
    
    @IBAction func tabGestureTabbed(_ sender: UITapGestureRecognizer) {
        movieTextView.resignFirstResponder()
    }
    
    @objc func closeButtonClicked(_ sender: UIBarButtonItem) {
        if navigationController?.presentingViewController != nil {
            // Navigation controller is being presented modally
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
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
        if let keyHeight {
            self.view.frame.size.height += keyHeight
        }
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

extension DetailViewController: UITextViewDelegate {
    
    // 텍스트뷰에 값이 바뀔 때마다 출력 ( ex) 글자수 체크 )
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
        if textView.text.count > 10 {
            let currentText = String(Array(textView.text).dropLast())
            textView.text = currentText
        }
        countLabel.text = "\(textView.text.count) / 10"
    }
    
    // TextView 내에 placeholder 같은 기능 만들기
    
    // 편집이 시작될 때 (커서가 시작될 때)
    // 플레이스홀더와 텍스트뷰 글자가 같다면 clear, color
    func textViewDidBeginEditing(_ textView: UITextView) {
        print(#function)
        if textView.text == DetailViewController.placeHolderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 편집이 끝날 때 (커서가 없어지는 순간)
    // 사용자가 아무 글자도 안썼으면 플레이스 홀더 글자 보이게 설정
    func textViewDidEndEditing(_ textView: UITextView) {
        print(#function)
        if textView.text.isEmpty {
            textView.text = DetailViewController.placeHolderText
            textView.textColor = .lightGray
        }
    }
}
