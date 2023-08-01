//
//  Movie.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/07/31.
//

import Foundation

struct Movie {
    var title: String
    var releaseDate: String
    var runtime: Int
    var overview: String
    var rate: Double
    
    var runtimeByHour: String {
        get {
            let hour = runtime / 60
            let min = runtime % 60
            return "상영시간: \(hour)시간\(min)분"
        }
    }
}
