//
//  FirstHeaderCollectionViewCell.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/08/02.
//

import UIKit

class FirstHeaderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FirstHeaderCollectionViewCell"
    
    @IBOutlet var headerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }
    
    func configureCell(row: SearchBook) {
//        guard let thumbnail = row.optThumbnail else {
//            headerImageView.backgroundColor = .systemGray4
//            return
//        }
//
//        headerImageView.kf.setImage(with: URL(string: thumbnail), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
    }
    
    private func designCell() {
        headerImageView.contentMode = .scaleAspectFill
        self.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }
    
}
