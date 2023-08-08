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
    
    @IBOutlet var thumbImageVIew: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }
    
    private func designCell() {
        titleLabel.font = .boldSystemFont(ofSize: 14)
        priceLabel.font = .systemFont(ofSize: 12, weight: .thin)
        contentLabel.font = .systemFont(ofSize: 12)
        
        thumbImageVIew.contentMode = .scaleAspectFit
    }
    
    func configCell(row: Book) {
        titleLabel.text = row.title
        priceLabel.text = "\(row.price)"
        contentLabel.text = row.contents
        
        thumbImageVIew.kf.setImage(with: URL(string: row.thumbnail), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
    }

}
