//
//  SeeAllViewController.swift
//  MovieApp
//
//  Created by srbrt on 10.02.2024.
//

import UIKit

class SeeAllViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func popViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
