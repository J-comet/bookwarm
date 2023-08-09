//
//  BookCollectionViewCell.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/08/08.
//

import UIKit
import Kingfisher

class BookCollectionViewCell: UICollectionViewCell {

    static let identifier = "BookCollectionViewCell"
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var thumbImageVIew: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }
    
    private func designCell() {
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 8
        containerView.layer.borderColor = UIColor.brown.cgColor
        
        titleLabel.numberOfLines = 2
        titleLabel.font = .boldSystemFont(ofSize: 12)
        titleLabel.textColor = .black
        priceLabel.font = .systemFont(ofSize: 10, weight: .thin)
        priceLabel.textColor = .lightGray
        contentLabel.font = .systemFont(ofSize: 10)
        contentLabel.textColor = .lightGray
        
        thumbImageVIew.contentMode = .scaleAspectFill
        thumbImageVIew.layer.cornerRadius = 8
    }
    
    func configureCell(row: Book) {
        titleLabel.text = row.title
        priceLabel.text = "\(row.salePrice)원"
        
        contentLabel.text = row.contents.isEmpty ? "내용이 없습니다" : row.contents
        
        if row.thumbnail.isEmpty {
            thumbImageVIew.backgroundColor = .systemGray4
        } else {
            thumbImageVIew.kf.setImage(with: URL(string: row.thumbnail), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        }
        
    }

}
