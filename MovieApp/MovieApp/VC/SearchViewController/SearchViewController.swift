//
//  SearchViewController.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import Lottie
import RxCocoa
import RxSwift
import UIKit
class SearchViewController: BaseViewController {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchImage: UIImageView!
    @IBOutlet var loader: LottieAnimationView!
    @IBOutlet var searchBar: UITextField!
    @IBOutlet var clearButton: UIButton!

    private let viewModel = SearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        observeLoading(viewModel: viewModel)
        setupUI()
    }

    private func setupUI() {
        searchBar.becomeFirstResponder()
        loader.loopMode = .loop
        clearButton.isHidden = true
        searchBar.delegate = self
        showLoader(isSearching: false)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: MoviesListCell.classname, bundle: nil), forCellWithReuseIdentifier: MoviesListCell.classname)

        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.viewModel.cancelRequest()
                if query.count > 0 {
                    self?.updateSearchResults(query: query)
                    self?.showLoader(isSearching: true)
                }

            })
            .disposed(by: disposeBag)
    }

    private func updateSearchResults(query: String) {
        viewModel.setupDataSource(query: query).subscribe { event in
            if let event = event.element, event {
                self.showLoader(isSearching: false)
                self.collectionView.reloadData()
            }
        }.disposed(by: disposeBag)
    }

    private func showLoader(isSearching: Bool) {
        searchImage.isHidden = isSearching
        loader.isHidden = !isSearching
        if isSearching {
            loader.play()
        } else {
            loader.stop()
        }
    }

    @IBAction func clearAction(_: Any) {
        searchBar.text = ""
        clearButton.isHidden = true
        showLoader(isSearching: false)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movieId = viewModel.getDataSource()[indexPath.row].id {
            let vc = DetailViewController(movieId: movieId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)

        clearButton.isHidden = newText.count > 0 ? false : true

        print("query \(newText.count)")
        return true
    }
}
