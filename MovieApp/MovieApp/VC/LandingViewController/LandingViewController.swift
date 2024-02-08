//
//  LandingViewController.swift
//  MovieApp
//
//  Created by srbrt on 8.02.2024.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var prevButton: UIButton!
    private let viewModel = LandingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: LandingCell.classname, bundle: nil), forCellWithReuseIdentifier: LandingCell.classname)
        setupBottomView(0)
    }
    
    @IBAction func prev(_ sender: Any) {
        guard let indexPaths = collectionView.indexPathsForVisibleItems.first else { return }
        
        let currentIndexPath = IndexPath(item: indexPaths.item - 1, section: indexPaths.section)
        if currentIndexPath.item == 0{
            self.prevButton.isHidden = true
        }
        if currentIndexPath.item >= 0 {
            collectionView.scrollToItem(at: currentIndexPath, at: .left, animated: true)
        }
        setupBottomView(currentIndexPath.item)
    }
    
    
    
    @IBAction func onNext(_ sender: Any) {
        guard let indexPaths = collectionView.indexPathsForVisibleItems.first else { return }
        
        let currentIndexPath = IndexPath(item: indexPaths.item + 1, section: indexPaths.section)
        if currentIndexPath.item < viewModel.getNumberOfInSection() {
            collectionView.scrollToItem(at: currentIndexPath, at: .left, animated: true)
            prevButton.isHidden = false
            setupBottomView(currentIndexPath.item)
            
        }
        
        if currentIndexPath.item == viewModel.getNumberOfInSection(){
            self.dismiss(animated: true)
        }
        
      
    }
    
    fileprivate func setupBottomView(_ currentIndexPath: Int) {
        let currentModel = viewModel.getCellForItem(indexPath: currentIndexPath)
        
        self.titleLbl.text = currentModel.title
        self.descriptionLbl.text = currentModel.description
    }
    
}

extension LandingViewController : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberOfInSection()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandingCell.classname, for: indexPath) as! LandingCell
        cell.setupCell(landindModel: viewModel.getCellForItem(indexPath: indexPath.row))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
