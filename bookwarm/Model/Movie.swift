//
//  Movie.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/07/31.
//

import UIKit

struct Movie {
    let title: String
    var releaseDate: String
    var runtime: Int
    var overview: String
    var rate: Double
    var isLike: Bool = false
    var categoryList: [String] = []
    var bgColor: UIColor = .randomColor
    
    var runtimeByHour: String {
        get {
            let hour = runtime / 60
            let min = runtime % 60
            return "상영시간: \(hour)시간\(min)분"
        }
    }
}
