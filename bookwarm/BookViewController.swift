//
//  BookViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire

class BookViewController: UIViewController, BaseViewControllerProtocol {
    
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
        designVC()
        configVC()
    }
    
    func designVC() {
        setCollectionViewLayout()
    }
    
    func configVC() {
        // searchBar 기능 추가
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        bookCollectionView.dataSource = self
        bookCollectionView.delegate = self
        
        let nib = UINib(nibName: BookCollectionViewCell.identifier, bundle: nil)
        bookCollectionView.register(nib, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
    }
    
    private func callRequest(searchText: String) {

        let parameters = ["query": searchText]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header)
            .validate()
            .responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                
                for item in json["documents"].arrayValue {
                    
                    var authors: [String] = []
                    
                    for author in item["authors"].arrayValue {
                        authors.append(author.stringValue)
                    }
                    
                    let book = Book(
                        authors: authors,
                        title: item["title"].stringValue,
                        contents: item["contents"].stringValue,
                        thumbnail: item["thumbnail"].stringValue,
                        salePrice: item["sale_price"].intValue == -1 ? item["price"].intValue : item["sale_price"].intValue
                    )
                    
                    self.searchList.append(book)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setCollectionViewLayout() {
        // 비율 계산해서 디바이스 별로 UI 설정
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let count: CGFloat = 2
        let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1)) // 디바이스 너비 계산
        
        layout.itemSize = CGSize(width: width / count, height: width / count)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)  // 컨텐츠가 잘리지 않고 자연스럽게 표시되도록 여백설정
        layout.minimumLineSpacing = spacing         // 셀과셀 위 아래 최소 간격
        layout.minimumInteritemSpacing = spacing    // 셀과셀 좌 우 최소 간격
        
        bookCollectionView.collectionViewLayout = layout  // layout 교체
    }
}

extension BookViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchList.removeAll()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchList.removeAll()
        callRequest(searchText: searchBar.text!)
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 실시간 검색 기능
//        callRequest(searchText: searchText)
    }
    
}

extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
        
        cell.configureCell(row: searchList[indexPath.row])
        return cell
    }
    
    
}
