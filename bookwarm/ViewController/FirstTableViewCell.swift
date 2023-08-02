//
//  FirstTableViewCell.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/08/02.
//

import UIKit

class FirstTableViewCell: UITableViewCell {
    
    static let identifier = "FirstTableViewCell"

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        designCell()
    }
    
    func configureCell(row: Movie) {
        mainImageView.image = UIImage(named: row.title)
        titleLabel.text = row.title
        infoLabel.text = row.releaseDate + " 영화"
        
        categoryLabel.isHidden = row.categoryList.isEmpty ? true : false
        
        var category = ""
        for cate in row.categoryList {
            category.append("[ \(cate) ] ")
        }
        categoryLabel.text = category
    }
    
    private func designCell() {
        mainImageView.contentMode = .scaleToFill
        mainImageView.layer.cornerRadius = 8
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = .black
        infoLabel.font = .systemFont(ofSize: 11)
        infoLabel.textColor = .lightGray
        categoryLabel.font = .italicSystemFont(ofSize: 10)
        categoryLabel.textColor = .red
    }
}
