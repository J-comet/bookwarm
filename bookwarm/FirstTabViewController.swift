//
//  FirstTabViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/08/02.
//

import UIKit
import RealmSwift

class FirstTabViewController: UIViewController, BaseViewControllerProtocol {
    
    @IBOutlet var headerCollectionView: UICollectionView!
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet var emptyLabel: UILabel!
    
    var searhList: Results<SearchBook>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        designVC()
        configVC()
        
        headerCollectionView.alwaysBounceHorizontal = true
        
        let tasks = RealmManager.shared.all(objectClass: SearchBook.self)
        
        let todosInProgress = tasks?.where {
            $0.title == "아이유"
        }
        
        let filters = RealmManager.shared.filterAll(objectClass: SearchBook.self) {
            $0.title == "호"
        }
        self.searhList = filters
//        self.searhList = tasks?.sorted(byKeyPath: "saveDate", ascending: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emptyLabel.isHidden = ((searhList?.count ?? 0) != 0) ? true : false
        headerCollectionView.reloadData()
    }
    
    func configNavigationBar() {
        title = "둘러보기"
    }
    
    func designVC() {
        mainTableView.separatorStyle = .none
        mainTableView.rowHeight = 100
        mainTableView.showsVerticalScrollIndicator = false
        mainTableView.sectionHeaderTopPadding = 16
    }
    
    func configVC() {
        let tableNib = UINib(nibName: FirstTableViewCell.identifier, bundle: nil)
        mainTableView.register(tableNib, forCellReuseIdentifier: FirstTableViewCell.identifier)
        
        let headerNib = UINib(nibName: FirstHeaderCollectionViewCell.identifier, bundle: nil)
        headerCollectionView.register(headerNib, forCellWithReuseIdentifier: FirstHeaderCollectionViewCell.identifier)
        
        mainTableView.dataSource = self
        mainTableView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.delegate = self
        
        configureHeaderView()
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
    
    private func moveDetailVC(row: Movie) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: DetailViewController.identifier) as! DetailViewController
        vc.movieData = row
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
        
        // branch test
    }
}

extension FirstTabViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieInfo.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FirstTableViewCell.identifier, for: indexPath) as? FirstTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(row: MovieInfo.list[indexPath.row])
        return cell
    }
    
    // 섹션별로 타이틀 지정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "요즘 인기 작품" : nil
    }
    
    // 테이블뷰 섹션 텍스트 스타일
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = .red  // 섹션의 백그라운드 컬러가 변경됨
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = .black
        header.textLabel?.font = .boldSystemFont(ofSize: 17)
//        header.textLabel?.frame = header.frame(forAlignmentRect: CGRect(x: 16, y: 0, width: 110, height: 21))
//        header.textLabel?.textAlignment = .center
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moveDetailVC(row: MovieInfo.list[indexPath.row])
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension FirstTabViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searhList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FirstHeaderCollectionViewCell.identifier, for: indexPath) as? FirstHeaderCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            guard let row = searhList?[indexPath.item] else { return cell }
            cell.configureCell(row: row)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        moveDetailVC(row: MovieInfo.list[indexPath.row])
    }
}
