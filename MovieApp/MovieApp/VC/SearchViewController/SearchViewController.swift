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
    private var empty: EmptyState?

    override func viewDidLoad() {
        super.viewDidLoad()

        observeLoading(viewModel: viewModel)
        setupUI()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.cancelRequest()
    }

    private func setupUI() {
        searchBar.becomeFirstResponder()
        loader.loopMode = .loop
        clearButton.isHidden = true
        searchBar.delegate = self
        showLoader(isSearching: false)
        searchBar.setPlaceholderColor(UIColor(white: 1, alpha: 0.5))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: MoviesListCell.classname, bundle: nil), forCellWithReuseIdentifier: MoviesListCell.classname)

        // Observing text changes in search bar
        searchBar.rx.text.orEmpty
            // Debouncing: Waits for 400 milliseconds after the user stops typing before emitting the current value.
            .debounce(.milliseconds(400), scheduler: MainScheduler.instance)
            // DistinctUntilChanged: Ensures that only distinct consecutive elements are emitted, ignoring consecutive duplicates.
            .distinctUntilChanged()
            // Subscribing to the observable sequence of text changes.
            .subscribe(onNext: { [weak self] query in
                // Cancelling any ongoing network requests to avoid unnecessary data fetches.
                self?.viewModel.cancelRequest()
                // Checking if the search query is not empty.
                if query.count > 0 {
                    // Updating search results based on the current query.
                    self?.updateSearchResults(query: query)
                    // Showing loader animation while searching.
                    self?.showLoader(isSearching: true)
                }
            })
            // Disposing the subscription when the view controller is deallocated to avoid memory leaks.
            .disposed(by: disposeBag)
    }

    private func updateSearchResults(query: String) {
        // Setting up data source based on the provided search query.
        viewModel.setupDataSource(query: query)
            // Subscribing to the observable sequence returned by `setupDataSource`.
            .subscribe { event in
                // Extracting the element from the event, which represents the result of the data source setup.
                if let event = event.element, event {
                    // If the event element is true, indicating that the setup was successful:

                    // Hiding the loader animation since the search operation is complete.
                    self.showLoader(isSearching: false)
                    self.showEmptyState(showEmpty: self.viewModel.getDataSource().isEmpty)
                    // Reloading the collection view to reflect the updated search results.
                    self.collectionView.reloadData()
                } else if event.error != nil {
                    self.showLoader(isSearching: false)
                }
            }
            // Disposing the subscription when the view controller is deallocated to avoid memory leaks.
            .disposed(by: disposeBag)
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

    func showEmptyState(showEmpty: Bool) {
        if showEmpty {
            empty = EmptyState(frame: collectionView.bounds)
            collectionView.backgroundView = empty
        } else {
            collectionView.backgroundView = nil
        }
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text ?? "") as NSString
        let newText = currentText.replacingCharacters(in: range, with: string)
        clearButton.isHidden = newText.count > 0 ? false : true
        return true
    }
}
