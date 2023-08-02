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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        recentArticleItemClicked(row: movieInfo.list[indexPath.row])
    }
    
    
    
    private func configureHeaderView() {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let count: CGFloat = 4
        let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1)) // 디바이스 너비 계산
        
        layout.itemSize = CGSize(width: width / count, height: (width / count) * 1.5)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)  // 컨텐츠가 잘리지 않고 자연스럽게 표시되도록
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)  // 컨텐츠가 잘리지 않고 자연스럽게 표시되도록 여백설정
        layout.minimumLineSpacing = 10        // 셀과셀 위 아래 최소 간격 (vertical) , 좌 우 최소 간격 (horizontal)
        layout.minimumInteritemSpacing = 0    // 셀과셀 좌 우 최소 간격 (vertical) , 위 아래 최소 간격 (horizontal)
        
        headerCollectionView.showsHorizontalScrollIndicator = false
        headerCollectionView.collectionViewLayout = layout
    }
    
    private func recentArticleItemClicked(row: Movie) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        vc.movieData = row
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
