//
//  MainCollectionViewController.swift
//  bookwarm
//
//  Created by 장혜성 on 2023/07/31.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: MovieCollectionViewCell.identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
    }
    
    @IBAction func searchBarItemClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: SearchViewController.identifier) as! SearchViewController
        // 2-1 (옵션). 네비게이션 컨트롤러가 있는 형태(제목)바로 Present 하고 싶은 경우
        // nav 를 사용한다면, present 와 화면 전환 방식도 nav 로 수정 해주어야함.
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        return cell
    }


}
