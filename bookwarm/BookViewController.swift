//
//  BookViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire

class BookViewController: UIViewController {
    
    static let identifier = "BookViewController"
    
    let url = "https://dapi.kakao.com/v3/search/book"
    let header: HTTPHeaders = ["Authorization":"KakaoAK \(APIKey.kakaoRESTKey)"]

    @IBOutlet var bookCollectionView: UICollectionView!
    let searchBar = UISearchBar()
    
    var searchList: [Book] = [] {
        didSet {
            bookCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // searchBar 기능 추가
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        callRequest(searchText: "korea")
    }
    
    private func callRequest(searchText: String) {
//        let text = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let parameters = ["query": searchText]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header)
            .validate()
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension BookViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
  
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 실시간 검색 기능
    }
}
