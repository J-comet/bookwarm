//
//  FirstTabViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/08/02.
//

import UIKit

class FirstTabViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet var headerCollectionView: UICollectionView!
    @IBOutlet var mainTableView: UITableView!
    
    var movieInfo = MovieInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "둘러보기"
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.delegate = self
        
        let nib = UINib(nibName: FirstHeaderCollectionViewCell.identifier, bundle: nil)
        headerCollectionView.register(nib, forCellWithReuseIdentifier: FirstHeaderCollectionViewCell.identifier)
        
        //        headerCollectionView.register(
        //                HeaderCollectionReusableView.self,
        //                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        //                withReuseIdentifier: HeaderCollectionReusableView.identifier
        //        )
        
        configureHeaderView()
    }
    
    // 테이블뷰 연결
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        guard let cell else { return UITableViewCell()}
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        print("출력?")
        return 100.0
    }
    
    // 컬렉션뷰 연결
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieInfo.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == headerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstHeaderCollectionViewCell.identifier, for: indexPath) as? FirstHeaderCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configureCell(row: movieInfo.list[indexPath.row])
            return cell
        } else {
            
            return UICollectionViewCell()
        }
    }
    
//    // 컬렉션뷰 섹션 타이틀
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        print("222222")
//        if kind == UICollectionView.elementKindSectionHeader {
//
//            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier,
//                                                                             for: indexPath)
//            return headerView
//
//        } else {
//            return UICollectionReusableView()
//        }
//    }
//
//    // 컬렉션뷰 헤더 높이
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        print("111111111")
//        return CGSize(width: collectionView.frame.width, height: 100)
//    }
    
    func configureHeaderView() {
        let layout = UICollectionViewFlowLayout()
        //        let width = UIScreen.main.bounds.width
        let width = 100.0
        let height = 150.0
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)  // 컨텐츠가 잘리지 않고 자연스럽게 표시되도록 여백설정
        layout.minimumLineSpacing = 10        // 셀과셀 위 아래 최소 간격 (vertical) , 좌 우 최소 간격 (horizontal)
        layout.minimumInteritemSpacing = 0    // 셀과셀 좌 우 최소 간격 (vertical) , 위 아래 최소 간격 (vertical)
        
        headerCollectionView.showsHorizontalScrollIndicator = false
        headerCollectionView.collectionViewLayout = layout
        mainTableView.tableHeaderView = headerCollectionView
    }
}
