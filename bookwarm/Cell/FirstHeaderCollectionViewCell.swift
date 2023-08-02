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
    
    func configureCell(row: Movie) {
        headerImageView.image = UIImage(named: row.title)
    }
    
    private func designCell() {
        headerImageView.contentMode = .scaleAspectFill
        self.backgroundColor = .clear
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }

}
