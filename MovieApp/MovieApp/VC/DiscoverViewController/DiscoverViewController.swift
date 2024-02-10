//
//  DiscoverViewController.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import RxSwift
import UIKit
class DiscoverViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var genresCollectionView: UICollectionView!

    private let viewModel = DiscoverViewModel()
    private var selectedGenre : GenreTitle = .all
    override func viewDidLoad() {
        super.viewDidLoad()
        observeLoading(viewModel: viewModel)
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: MoviesSectionCell.classname, bundle: nil), forCellReuseIdentifier: MoviesSectionCell.classname)
        genresCollectionView.delegate = self
        genresCollectionView.dataSource = self
        genresCollectionView.register(UINib(nibName: GenreCell.classname, bundle: nil), forCellWithReuseIdentifier: GenreCell.classname)
        genresCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        genresCollectionView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)

        viewModel.setupDataSource()?.subscribe { event in
            if let event = event.element, event {
                self.tableView.reloadData()
            } else if let error = event.error {
                print("error :\(error.localizedDescription)")
            }
        }.disposed(by: disposeBag)
    }
}

extension DiscoverViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.getGenresSource().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.classname, for: indexPath) as! GenreCell
        cell.setupCell(genreTitle: viewModel.getGenresSource()[indexPath.row])
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        genresCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.selectedGenre = viewModel.getGenresSource()[indexPath.row]
        viewModel.setupDataSource(genre: selectedGenre)?.subscribe { _ in
            self.tableView.reloadData()
        }.disposed(by: disposeBag)
    }
}

extension DiscoverViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 1
    }

    func numberOfSections(in _: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: MoviesSectionCell.classname, for: indexPath) as? MoviesSectionCell {
            cell.selectionStyle = .none
            cell.setupCell(dataSource: viewModel.getSection(section: indexPath.section), index: indexPath.section,genre: self.selectedGenre)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return tableView.frame.width / 1.4
    }
}

func calculateLabelWidth(text: String, font: UIFont) -> CGFloat {
    let fontAttributes = [NSAttributedString.Key.font: font]
    let size = (text as NSString).size(withAttributes: fontAttributes)
    return size.width
}

extension DiscoverViewController: DidSelectMovie {
    func didSelectMovie(movieId: Int) {
        if movieId != 0 {
            let vc = DetailViewController(movieId: movieId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func seeAll(genre: Int, section: Int) {
        let vc = SeeAllViewController(genre: GenreTitle(rawValue: genre) ?? .all, section: MovieSectionType(rawValue: section) ?? .nowPlaying)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
