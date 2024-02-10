//
//  DetailViewController.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit
import RxSwift
class DetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private let viewModel = DetailViewModel()
    
    private let movieId : Int
    private var isExpanded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        observeLoading(viewModel: viewModel)
        setupUI()
        
    }

    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: "DetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: DetailHeaderCell.classname, bundle: nil), forCellReuseIdentifier: DetailHeaderCell.classname)
        tableView.register(UINib(nibName: DetailCell.classname, bundle: nil), forCellReuseIdentifier: DetailCell.classname)
        tableView.register(UINib(nibName: CastCell.classname, bundle: nil), forCellReuseIdentifier: CastCell.classname)
        tableView.register(UINib(nibName: MoviesSectionCell.classname, bundle: nil), forCellReuseIdentifier: MoviesSectionCell.classname)
        tableView.contentInsetAdjustmentBehavior = .never
        viewModel.loadDetail(id: movieId).subscribe {[weak self] event in
            if event.element ?? false{
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }else{
                
            }
        }.disposed(by: self.disposeBag)
    }
    
    @IBAction func popViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension DetailViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailHeaderCell.classname, for: indexPath) as! DetailHeaderCell
            cell.setup(dataSource: viewModel.getHeaderDataSource() , reloadData : !viewModel.getHeaderDataSource().isEmpty)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: DetailCell.classname, for: indexPath) as! DetailCell
            cell.setupUI(detail: viewModel.detailSource, isExpanded: self.isExpanded , indexPath : indexPath)
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: CastCell.classname, for: indexPath) as! CastCell
            cell.setupUI(dataSoure: viewModel.getCastDataSource(), reloadData: viewModel.getCastDataSource().count > 0)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: MoviesSectionCell.classname, for: indexPath) as! MoviesSectionCell
            cell.selectionStyle = .none
            cell.setupSimilarCell(data: viewModel.getSimilarDataSource(), reloadData: viewModel.getCastDataSource().count > 0)
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section{
        case 0: return  viewModel.getHeaderDataSource().isEmpty ?  0 : self.view.frame.width * 4 / 5
        case 1 : return viewModel.detailSource == nil ? 0 :  UITableView.automaticDimension
        case 2 : return  viewModel.getCastDataSource().count > 0 ? self.view.frame.height / 5 : 0
        case 3:  return  viewModel.getSimilarDataSource().count > 0 ?  self.view.frame.width / 2 : 0
        default : return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
   
}
extension DetailViewController : DidSelectMovie{
    func didSelecetSimilar(movieId: Int) {
        if movieId != 0{
            let vc = DetailViewController(movieId: movieId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension DetailViewController : DetailCellDelegate{
    func readMoreLess(isExpanded: Bool, indexPath: IndexPath?) {
        guard let indexPath else { return }
        self.isExpanded = !isExpanded
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
