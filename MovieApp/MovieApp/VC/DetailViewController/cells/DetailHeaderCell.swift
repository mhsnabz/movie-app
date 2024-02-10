//
//  DetailHeaderCell.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit

class DetailHeaderCell: UITableViewCell {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dataSource = [DetailHeaderModel]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setup(dataSource : [DetailHeaderModel] , reloadData : Bool){
       
        if reloadData{
            self.dataSource = dataSource
            collectionView.reloadData()
            pageControl.numberOfPages = dataSource.count
        }else{
            collectionView.register(UINib(nibName: DetailImageCell.classname, bundle: nil), forCellWithReuseIdentifier: DetailImageCell.classname)
            collectionView.register(UINib(nibName: DetailVideoCell.classname, bundle: nil), forCellWithReuseIdentifier:DetailVideoCell.classname)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        pageControl.currentPage = Int(targetContentOffset.pointee.x / frame.width)
    }
}

extension DetailHeaderCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = dataSource[indexPath.item]
        
        switch data.type{
        case .image:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.classname, for: indexPath) as! DetailImageCell
            cell.setupUI(data: dataSource[indexPath.row])
            return cell
        case .video:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailVideoCell.classname, for: indexPath) as! DetailVideoCell
            return cell
        case .none :
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}
