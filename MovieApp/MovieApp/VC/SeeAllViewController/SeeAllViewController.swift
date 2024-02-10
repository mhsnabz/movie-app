//
//  SeeAllViewController.swift
//  MovieApp
//
//  Created by srbrt on 10.02.2024.
//

import UIKit

class SeeAllViewController: BaseViewController {
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func popViewController(_: Any) {
        navigationController?.popViewController(animated: true)
    }
}
