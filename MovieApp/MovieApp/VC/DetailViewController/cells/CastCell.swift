//
//  CastCell.swift
//  MovieApp
//
//  Created by srbrt on 10.02.2024.
//

import UIKit

class CastCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource = [Cast]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setupUI(dataSoure : [Cast] , reloadData : Bool){
        if reloadData{
            self.dataSource = dataSoure
            collectionView.reloadData()
        }else{
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.register(UINib(nibName: ArtistCell.classname, bundle: nil), forCellWithReuseIdentifier: ArtistCell.classname)
        }
        
    }
    
}

extension CastCell : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtistCell.classname, for: indexPath) as! ArtistCell
        cell.setupCell(cast: dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let h = collectionView.frame.height - 4
        let w = h * 9 / 13
        return CGSize(width: w, height: h)
    }
}
