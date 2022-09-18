//
//  VideoTableViewCell.swift
//  Ogr_AVKit
//
//  Created by teyhan.uslu on 3.08.2022.
//

import UIKit
import AVKit
import AVFoundation
import Kingfisher

class HomePageTableViewCell: UITableViewCell {

    @IBOutlet var imageV: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!

    override func awakeFromNib() {
        super.awakeFromNib()
        progressView.tintColor = .red
        progressView.backgroundColor = .systemGray4
    }

    func prepareCell(video: Video){
        let videoURL = URL(string: video.url)
        let asset = AVAsset(url: videoURL!)

        nameLabel.text = video.name

        let imageUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/\(video.imageUrl)")
        imageV.kf.setImage(with: imageUrl)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            let duration = asset.duration
            if CMTIME_IS_INVALID(duration) || duration.value == 0 { return }
            print(Float(CMTimeGetSeconds(video.lastDuration) / CMTimeGetSeconds(duration)))
            progressView.setProgress(Float(CMTimeGetSeconds(video.lastDuration) / CMTimeGetSeconds(duration)), animated: true)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
