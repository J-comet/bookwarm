//
//  BookViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire
import RealmSwift

class BookViewController: UIViewController, BaseViewControllerProtocol {
    
    static let identifier = "BookViewController"
    
    let url = "https://dapi.kakao.com/v3/search/book"
    let header: HTTPHeaders = ["Authorization":"KakaoAK \(APIKey.kakaoRESTKey)"]
    
    @IBOutlet var bookCollectionView: UICollectionView!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var emptyLabel: UILabel!
    
    let searchBar = UISearchBar()
    
    var searchList: [Book] = [] {
        didSet {
            bookCollectionView.reloadData()
        }
    }
    
    var page = 1
    var isEnd = false
    
    var isScrollingPaging = true  // (스크롤 제어) 스크롤로 페이징처리 , 페이징 시작할 때 false , 통신 완료 후 다시 true 로 변경
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designVC()
        configVC()
        indicatorView.hidesWhenStopped = true
    }
    
    func designVC() {
        setCollectionViewLayout()
    }
    
    func configVC() {
        bookCollectionView.refreshControl = UIRefreshControl()
        bookCollectionView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        bookCollectionView.refreshControl?.tintColor = .green
        
        // searchBar 기능 추가
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        bookCollectionView.dataSource = self
        bookCollectionView.delegate = self
        //        bookCollectionView.prefetchDataSource = self  // scrollview offset 으로 페이징 테스트 중
        
        let nib = UINib(nibName: BookCollectionViewCell.identifier, bundle: nil)
        bookCollectionView.register(nib, forCellWithReuseIdentifier: BookCollectionViewCell.identifier)
    }
    
    @objc func refreshData() {
        page = 1
        callRequest(page: page, searchText: searchBar.text!)
    }
    
    private func callRequest(page: Int, searchText: String) {
        
        indicatorView.startAnimating()
        let parameters = [
            "page": "\(page)",
            "size": "20",
            "query": searchText,
            "target": "title"
        ]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: header)
            .validate(statusCode: 200...500)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    
                    //                print(response.request?.urlRequest)
                    
                    self.isEnd = json["meta"]["is_end"].boolValue
                    
                    print("isEnd = ", self.isEnd)
                    
                    self.emptyLabel.isHidden = self.isEnd && self.searchList.isEmpty ? false : true
                    
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
                
                self.indicatorView.stopAnimating()
                self.isScrollingPaging = true
                self.bookCollectionView.refreshControl?.endRefreshing()
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
        page = 1
        callRequest(page: page, searchText: searchBar.text!)
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 실시간 검색 기능
        //        callRequest(searchText: searchText)
    }
    
}

extension BookViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        let collectionViewHeight = self.bookCollectionView.contentSize.height
        
        //        print()
        //        print("scroll = \(scrollOffset)")
        //        print("collectionView / 2 = \(collectionViewHeight / 2)")
        
        let pagingPosition = collectionViewHeight * 0.3
        
        if scrollOffset > collectionViewHeight - pagingPosition && self.isScrollingPaging {
            isScrollingPaging = false
            if page < 50 && !isEnd {
                page += 1
                callRequest(page: page, searchText: searchBar.text!)
            }
            print("페이징")
        } else {
            //            print("페이징 처리 중으로 스크롤 동작 막기")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if searchList.count - 1 == indexPath.row && page < 50 && !isEnd {
                page += 1
                callRequest(page: page, searchText: searchBar.text!)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        // 용량이 큰 파일을 데이터로 받는데 유저가 스크롤 빨리하면 굳이 큰 용량을 로드할 필요가 없기 때문에 취소작업을 추가!!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookCollectionViewCell.identifier, for: indexPath) as! BookCollectionViewCell
        
        cell.configureCell(row: searchList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = searchList[indexPath.row]
        print(row)
        
        RealmManager.shared.add(
            obj: SearchBook(
                title: row.title,
                optContents: row.contents,
                optThumbnail: row.thumbnail
            )
        )
    }
    
}
