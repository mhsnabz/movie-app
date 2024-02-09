//
//  DiscoverViewController.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import UIKit
import RxSwift
class DiscoverViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var genresCollectionView: UICollectionView!
    private let viewModel = DiscoverViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        observeLoading(viewModel: viewModel)
    
        setupUI()
    }
    
    private func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MoviesSectionCell.classname, bundle: nil), forCellReuseIdentifier: MoviesSectionCell.classname)
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
        genresCollectionView.register(UINib(nibName: GenreCell.classname, bundle: nil), forCellWithReuseIdentifier: GenreCell.classname)
        genresCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        genresCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        
        viewModel.setupDataSource()?.subscribe({ event in
            if let event = event.element , event{
                self.tableView.reloadData()
            }else if let error = event.error{
                print("error :\(error.localizedDescription)")
            }
        }).disposed(by: self.disposeBag)
       
    }

}

extension DiscoverViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return self.viewModel.getGenresSource().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.classname, for: indexPath) as! GenreCell
        cell.setupCell(genreTitle: viewModel.getGenresSource()[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.genresCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.viewModel.filterResultsByGenre(viewModel.getGenresSource()[indexPath.row]) { isDone in
            self.tableView.scrollsToTop = true  
            self.tableView.reloadData()
        }
    }
    
}

extension DiscoverViewController : UITableViewDelegate  , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  viewModel.getNumberSection()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MoviesSectionCell.classname, for: indexPath) as? MoviesSectionCell{
            cell.selectionStyle = .none
            cell.setupCell(dataSource: viewModel.getSection(section: indexPath.section), index: indexPath.section)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.width / 1.4
    }
}

func calculateLabelWidth(text: String, font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = (text as NSString).size(withAttributes: fontAttributes)
    return size.width
}
