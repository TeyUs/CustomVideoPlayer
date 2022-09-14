//
//  ViewController.swift
//  Ogr_AVKit
//
//  Created by teyhan.uslu on 2.08.2022
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var videoView: UIView!
    
    let video_Url = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }

    var player: AVPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()

//        let videoURL = URL(string: video_Url)
//        let player = AVPlayer(url: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }
//


        let tapGest = UITapGestureRecognizer(target: self, action: #selector(videoTapped))

        let videoURL = URL(string: video_Url)
        player = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer)
        videoView.addGestureRecognizer(tapGest)


//        playerLayer.frame = CGRect(x: self.view.frame.width/2, y: self.view.frame.height/2, width: self.view.frame.width/2, height: self.view.frame.height/2)

//        self.view.layer.addSublayer(playerLayer)
        player.play()


    }

    @objc func videoTapped(){
        if player.timeControlStatus == .paused{
            player.play()
        }else if player.timeControlStatus == .playing{
            player.pause()
        }
    }

    @IBAction func sa(_ sender: Any) {
        player.pause()
        performSegue(withIdentifier: "goToVideoTableView", sender: nil)
    }

    @IBAction func otherPage(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoScreenViewController") as! VideoScreenViewController
        vc.video = videos[2]
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

