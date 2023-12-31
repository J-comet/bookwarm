//
//  MovieCollectionViewCell.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/07/31.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "MovieCollectionViewCell"
    
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var likeButton: UIButton!
    
    // 셀 생명주기 관련??
    override func prepareForReuse() {
        super.prepareForReuse()
        // 셀 재사용 중 이미지가 뒤섞여나올 떄
        mainImageView.image = UIImage(systemName: "ellipsis.circle.fill")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // 스토리 기반, xib 등으로 셀을 다룰 경우메만 호출됨.
        // 코드 기반으로 할 때는 init 로 대신 사용
        designCell()
    }
    
    func configureCell(row: Movie) {
        containerView.backgroundColor = row.bgColor
        titleLabel.text = row.title
        rateLabel.text = "\(row.rate)"
        mainImageView.image = UIImage(named: row.title)
        
        if row.isLike {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    private func designCell() {
    
        containerView.layer.cornerRadius = 12
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .white
        rateLabel.textColor = .white
        rateLabel.font = .systemFont(ofSize: 12)
        mainImageView.contentMode = .scaleAspectFit
    }
    
//    private func getRandomColor() -> UIColor {
//        let red = CGFloat.random(in: 50..<255)
//        let green = CGFloat.random(in: 50..<255)
//        let blue = CGFloat.random(in: 50..<255)
//        return UIColor(red:red/255.0, green:green/255.0, blue:blue/255.0, alpha:1.0)
//    }
}
