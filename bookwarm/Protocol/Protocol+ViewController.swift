//
//  Protocol+ViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/08/03.
//

import Foundation

@objc
protocol BaseViewControllerProtocol {
//    @objc optional var navigationTitle: String {get set}
    @objc optional func configNavigationBar()
    func designVC()
    func configVC()
}
