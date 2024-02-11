//
//  SeeAllViewController.swift
//  MovieApp
//
//  Created by srbrt on 10.02.2024.
//

import RxSwift
import UIKit
class SeeAllViewController: BaseViewController {
    @IBOutlet var collectionView: UICollectionView!

    private var genre: GenreTitle?
    private var section: MovieSectionType?
    private var similarMovies: Int?
    private let viewModel = SeeAllViewModel()

    private var showFooterView: Bool = false {
        didSet {
            self.collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        observeLoading(viewModel: viewModel)
        setupUI()
    }

    init(genre: GenreTitle?, section: MovieSectionType?, similarMovies: Int? = nil) {
        self.genre = genre
        self.section = section
        self.similarMovies = similarMovies
        super.init(nibName: "SeeAllViewController", bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func popViewController(_: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: MoviesListCell.classname, bundle: nil), forCellWithReuseIdentifier: MoviesListCell.classname)
        collectionView.contentInset = UIEdgeInsets(top: view.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        
        viewModel.setupDataSource(genre: genre, section: section, page: 1, similarMovies: similarMovies)?.subscribe { _ in
            self.collectionView.reloadData()
        }.disposed(by: disposeBag)
    }
}

extension SeeAllViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.getDataSource().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoviesListCell.classname, for: indexPath) as! MoviesListCell
        cell.setupCell(result: viewModel.getDataSource()[indexPath.row], section: -1)
        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let w = (collectionView.frame.width - 12) / 2
        let h = w * 13 / 9
        return CGSize(width: w, height: h)
    }

  
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 12
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForFooterInSection _: Int) -> CGSize {
        return !showFooterView ? CGSize(width: collectionView.frame.width, height: 50) : .zero
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = viewModel.getDataSource()[indexPath.row].id {
            let vc = DetailViewController(movieId: movieId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.item, "\(viewModel.getDataSource().count)")
        if indexPath.item == viewModel.getDataSource().count - 1 && !viewModel.isLoadingMoreItem() {
            viewModel.setIsLoadingMore(isLoading: true)
            showFooterView = viewModel.isLoadingMoreItem()
            viewModel.cancelRequest()

            viewModel.setupDataSource(genre: genre, section: section, page: viewModel.currentPage + 1, isLoadingMore: true, similarMovies: similarMovies)?.subscribe { [weak self] event in
                if let event = event.element {
                    if event {
                        self?.viewModel.setIsLoadingMore(isLoading: false)
                        self?.showFooterView = false
                    }
                } else if let _ = event.error {
                    self?.viewModel.setIsLoadingMore(isLoading: false)
                    self?.showFooterView = false
                }
            }.disposed(by: disposeBag)
        } else {
            viewModel.cancelRequest()
        }
    }
}
