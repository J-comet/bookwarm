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
        headerImageView.contentMode = .scaleAspectFill
    }
    
    func configureCell(row: Movie) {
        print(row.title)
        headerImageView.image = UIImage(named: row.title)
    }

}
