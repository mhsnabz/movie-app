//
//  LandingViewController.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import UIKit

class LandingViewController: BaseViewController {
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var bottomView: UIView!

    @IBOutlet var prevButton: UIButton!
    private let viewModel = LandingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startLoading()
    }

    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: LandingCell.classname, bundle: nil), forCellWithReuseIdentifier: LandingCell.classname)
        setupBottomView(0)
    }

    @IBAction func prev(_: Any) {
        guard let indexPaths = collectionView.indexPathsForVisibleItems.first else { return }

        let currentIndexPath = IndexPath(item: indexPaths.item - 1, section: indexPaths.section)
        if currentIndexPath.item == 0 {
            prevButton.isHidden = true
        }
        if currentIndexPath.item >= 0 {
            collectionView.scrollToItem(at: currentIndexPath, at: .left, animated: true)
        }
        setupBottomView(currentIndexPath.item)
    }

    @IBAction func onNext(_: Any) {
        guard let indexPaths = collectionView.indexPathsForVisibleItems.first else { return }

        let currentIndexPath = IndexPath(item: indexPaths.item + 1, section: indexPaths.section)
        if currentIndexPath.item < viewModel.getNumberOfInSection() {
            collectionView.scrollToItem(at: currentIndexPath, at: .left, animated: true)
            prevButton.isHidden = false
            setupBottomView(currentIndexPath.item)
        }

        if currentIndexPath.item == viewModel.getNumberOfInSection() {
            dismiss(animated: true)
        }
    }

    fileprivate func setupBottomView(_ currentIndexPath: Int) {
        let currentModel = viewModel.getCellForItem(indexPath: currentIndexPath)

        titleLbl.text = currentModel.title
        descriptionLbl.text = currentModel.description
    }
}

extension LandingViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return viewModel.getNumberOfInSection()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandingCell.classname, for: indexPath) as! LandingCell
        cell.setupCell(landindModel: viewModel.getCellForItem(indexPath: indexPath.row))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt _: Int) -> CGFloat {
        return 0
    }
}
