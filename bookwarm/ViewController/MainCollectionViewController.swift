//
//  MainCollectionViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/07/31.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {

    
    var movieInfo = MovieInfo()
    
    let searchBar = UISearchBar()
    
    var searchList: [Movie] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비컨트롤러 스와이프로 뒤로가기 활성화
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        let nib = UINib(nibName: MovieCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        setCollectionViewLayout()
        
        // searchBar 기능 추가
        searchBar.showsCancelButton = true
        navigationItem.titleView = searchBar
        searchBar.delegate = self
        
        searchList = movieInfo.list
    }
    
    //    @IBAction func searchBarItemClicked(_ sender: UIBarButtonItem) {
    //        let sb = UIStoryboard(name: "Main", bundle: nil)
    //        let vc = sb.instantiateViewController(withIdentifier: SearchViewController.identifier) as! SearchViewController
    //        // 2-1 (옵션). 네비게이션 컨트롤러가 있는 형태(제목)바로 Present 하고 싶은 경우
    //        // nav 를 사용한다면, present 와 화면 전환 방식도 nav 로 수정 해주어야함.
    //        let nav = UINavigationController(rootViewController: vc)
    //        nav.modalPresentationStyle = .fullScreen
    //        present(nav, animated: true)
    //    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        
        // 각 버튼마다 태그 추가
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        
        cell.configureCell(row: searchList[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("1234")
//        self.collectionView.endEditing(true)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        let row = searchList[indexPath.row]
        vc.movieData = row

        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 컬렉션뷰 레이아웃 잡기
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
        
        collectionView.collectionViewLayout = layout  // layout 교체
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        // 버튼에 지정해둔 tag (indexPath.row) 로 해당값 찾기
        searchList[sender.tag].isLike.toggle()
        //        collectionView.reloadData()
    }
    
    private func searchAction() {
        searchList.removeAll()
        for movie in movieInfo.list {
            if movie.title.uppercased().contains(searchBar.text!) {
                searchList.append(movie)
            }
        }
    }
    
}

extension MainCollectionViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchList = movieInfo.list
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchAction()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchAction()
        if searchText.count == 0 {
            searchList = movieInfo.list
        }
    }
    
}

extension MainCollectionViewController: UIGestureRecognizerDelegate {
    // 네비컨트롤러 스와이프로 뒤로가기 활성화
}
