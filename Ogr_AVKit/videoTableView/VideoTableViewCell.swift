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

class VideoTableViewCell: UITableViewCell {

    @IBOutlet var imageV: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!

    var player: AVPlayer!

    override func awakeFromNib() {
        super.awakeFromNib()

//        let tapGest = UITapGestureRecognizer(target: self, action: #selector(videoTapped))
//        videoView.addGestureRecognizer(tapGest)
        
        progressView.tintColor = .red
        progressView.backgroundColor = .systemGray4
    }

    func prepareCell(rowAt: Int){
        let video = videos[rowAt]
        let videoURL = URL(string: video.url)
        let asset = AVAsset(url: videoURL!)

        nameLabel.text = video.name
        print("*********************************************")
        let str = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/\(video.imageUrl)"
        print(str)
        let imageUrl = URL(string: str)
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

//    @objc func videoTapped(){
//        print("tapped cell video")
//        
//        if player.timeControlStatus == .paused{
//            player.play()
//            print("play")
//        }else if player.timeControlStatus == .playing{
//            print("pause")
//            player.pause()
//        }
//    }
}
