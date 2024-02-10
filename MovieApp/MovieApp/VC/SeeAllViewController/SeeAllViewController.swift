//
//  SeeAllViewController.swift
//  MovieApp
//
//  Created by srbrt on 10.02.2024.
//

import UIKit
import RxSwift
class SeeAllViewController: BaseViewController {
    @IBOutlet var collectionView: UICollectionView!

    private var genre : GenreTitle?
    private var section : MovieSectionType?
    private var similarMovies : Int?
    private let viewModel = SeeAllViewModel()
    
    private var showFooterView : Bool = false{
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeLoading(viewModel: viewModel)
        setupUI()
    }
    
    init( genre: GenreTitle?, section: MovieSectionType?,similarMovies : Int? = nil) {
        self.genre = genre
        self.section = section
        self.similarMovies = similarMovies
        super.init(nibName: "SeeAllViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func popViewController(_: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    
    private func setupUI(){
        collectionView.delegate = self
        collectionView.dataSource  = self
        collectionView.register(UINib(nibName: MoviesListCell.classname , bundle: nil), forCellWithReuseIdentifier: MoviesListCell.classname)
        collectionView.register(FooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")

        collectionView.contentInset = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        viewModel.setupDataSource(genre: self.genre,section: self.section, page: 1,similarMovies: self.similarMovies)?.subscribe({ event in
            self.collectionView.reloadData()
        }).disposed(by: self.disposeBag)
    }

}


extension SeeAllViewController  : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDataSource().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesListCell.classname, for: indexPath) as! MoviesListCell
        cell.setupCell(result: viewModel.getDataSource()[indexPath.row], section: -1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = (self.collectionView.frame.width - 12) / 2
        let h = w * 13 / 9
        return CGSize(width: w, height: h)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
          case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath)
            footerView.backgroundColor = .red
            return footerView
          default:
              fatalError("Unexpected element kind")
          }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

        return  !showFooterView ? CGSize(width: self.collectionView.frame.width, height: 50) : .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = viewModel.getDataSource()[indexPath.row].id{
            let vc = DetailViewController(movieId: movieId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.item ,"\(viewModel.getDataSource().count)")
        if indexPath.item  == viewModel.getDataSource().count - 1 && !viewModel.isLoadingMoreItem(){
            viewModel.setIsLoadingMore(isLoadig: true)
            self.showFooterView = viewModel.isLoadingMoreItem()
            viewModel.cancelRequest()
            
            viewModel.setupDataSource(genre: self.genre, section: section, page: viewModel.currentPage + 1,isLoadingMore: true,similarMovies: self.similarMovies)?.subscribe({[weak self] event in
                if let event = event.element{
                    if event{
                        self?.viewModel.setIsLoadingMore(isLoadig: false)
                        self?.showFooterView = false
                    }
                }else if let _ = event.error{
                    self?.viewModel.setIsLoadingMore(isLoadig: false)
                    self?.showFooterView = false
                }
            }).disposed(by: self.disposeBag)
        }else{
            viewModel.cancelRequest()
        }
    }
}
