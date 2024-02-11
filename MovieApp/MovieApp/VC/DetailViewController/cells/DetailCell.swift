//
//  DetailCell.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit

protocol DetailCellDelegate: AnyObject {
    func readMoreLess(isExpanded: Bool, indexPath: IndexPath?)
}

class DetailCell: UITableViewCell {
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var descriptionLbl: UILabel!
    @IBOutlet var detailLbl: UILabel!

    @IBOutlet var avarageVote: UILabel!

    private var isExpanded = false
    private var indexPath: IndexPath?
    weak var delegate: DetailCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setupUI(detail: DetailModel?, isExpanded: Bool, indexPath: IndexPath) {
        self.isExpanded = isExpanded
        self.indexPath = indexPath
        if let title = detail?.originalTitle {
            titleLbl.text = title
        }

        if let avarageVote = detail?.voteAverage, let id = detail?.genres, let date = detail?.releaseDate {
            self.avarageVote.text = avarageVote.rounded(toDecimalPlaces: 1)
            var genre = ""
            id.forEach { id in
                genre = genre + "," + (GenreTitle(rawValue: id.id ?? -1)?.name ?? "")
            }
            let index = genre.index(genre.startIndex, offsetBy: 0)
            if genre.count > 0 {
                genre.remove(at: index)
            }
            detailLbl.getBullet(genre: genre, date: date, vote: "2h 30m")
        }

        if let desp = detail?.overview {
            if self.isExpanded {
                let readMoreText = "Read Less"
                let fullText = "\(desp)\(readMoreText)"
                let attributedString = NSMutableAttributedString(string: fullText)
                let range = (fullText as NSString).range(of: readMoreText)
                attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
                descriptionLbl.attributedText = attributedString
            } else {
                if desp.count > 79 {
                    let index = desp.index(desp.startIndex, offsetBy: 80)
                    let readMoreText = "Read More"
                    let fullText = "\(String(desp.prefix(upTo: index))).. \(readMoreText)"
                    let attributedString = NSMutableAttributedString(string: fullText)
                    let range = (fullText as NSString).range(of: readMoreText)
                    attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: range)
                    descriptionLbl.attributedText = attributedString
                }
            }
        }
        descriptionLbl.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeStatus)))
    }

    @objc func changeStatus() {
        delegate?.readMoreLess(isExpanded: isExpanded, indexPath: indexPath)
    }
}
