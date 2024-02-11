//
//  DetailVideoCell.swift
//  MovieApp
//
//  Created by srbrt on 9.02.2024.
//

import UIKit
import WebKit
class DetailVideoCell: UICollectionViewCell {
    @IBOutlet var webView: WKWebView!

    var url: String = "https://www.youtube.com/embed/%@"
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(videoPath: String?) {
        if let videoPath, let url = URL(string: String(format: url, videoPath)) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }

    func stopVideo() {
        webView.stopLoading()
        webView.configuration.userContentController.removeAllUserScripts()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        stopVideo()
    }
}
