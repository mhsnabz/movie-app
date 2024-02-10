//
//  MoviesSectionCell.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit

@objc protocol DidSelectMovie: AnyObject{
    @objc optional func didSelectMovie(movieId : Int)
    @objc optional func didSelecetSimilar(movieId: Int)
}

class MoviesSectionCell: UITableViewCell {
    @IBOutlet var collecitonView: UICollectionView!
    @IBOutlet var titlLbl: UILabel!

    weak var delegate : DidSelectMovie?
    private var dataSource: MovieListModel?
    private var similarDataSource : [SimilarResult]?
    private var sectionIndex: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(dataSource: MovieListModel, index: Int) {
        if index == 0 {
            titlLbl.text = "Now Playing"
        } else if index == 1 {
            titlLbl.text = "Popular"
        } else if index == 2 {
            titlLbl.text = "Top Rated"
        } else if index == 3 {
            titlLbl.text = "Upcoming"
        }
        sectionIndex = index
        self.dataSource = dataSource

        collecitonView.delegate = self
        collecitonView.dataSource = self
        collecitonView.register(UINib(nibName: MoviesListCell.classname, bundle: nil), forCellWithReuseIdentifier: MoviesListCell.classname)
        collecitonView.register(UINib(nibName: NowPlayingCell.classname, bundle: nil), forCellWithReuseIdentifier: NowPlayingCell.classname)
        collecitonView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        collecitonView.reloadData()
    }
    
    func setupSimilarCell(data : [SimilarResult] , reloadData : Bool){
        if reloadData{
            self.similarDataSource = data
            self.collecitonView.reloadData()
        }else{
            titlLbl.text = "More Like This"
            collecitonView.delegate = self
            collecitonView.dataSource = self
            collecitonView.register(UINib(nibName: MoviesListCell.classname, bundle: nil), forCellWithReuseIdentifier: MoviesListCell.classname)
            collecitonView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
            collecitonView.reloadData()
        }
        
    }
}

extension MoviesSectionCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return  similarDataSource != nil ? similarDataSource?.count ?? 0 : dataSource?.results?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if sectionIndex == 0 && similarDataSource == nil {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NowPlayingCell.classname, for: indexPath) as! NowPlayingCell
            if let result = dataSource?.results {
                cell.setupUI(movieListModel: result[indexPath.row])
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesListCell.classname, for: indexPath) as! MoviesListCell
            if let result = dataSource?.results {
                cell.setupCell(result: result[indexPath.row], section: sectionIndex)
            }else if let result = similarDataSource{
                cell.setupSimilarCell(result: result[indexPath.row])
            }
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        if sectionIndex == 0 {
            let h = collectionView.frame.height
            let w = h * 11 / 9

            return CGSize(width: w, height: h)
        } else {
            let w = collectionView.frame.width / 3
            let h = w * 14 / 9
            return CGSize(width: w, height: h)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if similarDataSource != nil{
            delegate?.didSelecetSimilar?(movieId: similarDataSource?[indexPath.row].id ?? 0)
        }else{
            delegate?.didSelectMovie!( movieId: dataSource?.results?[indexPath.row].id ?? 0)
        }
        
    }
}
