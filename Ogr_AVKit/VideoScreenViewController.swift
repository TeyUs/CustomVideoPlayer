//
//  VideoScreenViewController.swift
//  Ogr_AVKit
//
//  Created by teyhan.uslu on 7.08.2022.
//

import UIKit
import AVKit
import AVFoundation

class VideoScreenViewController: UIViewController {
    var player: AVPlayer!
    var videoController: VideoControlsView!
    var asset: AVAsset!
    var video:Video!
    var tap: UITapGestureRecognizer!

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .landscapeRight }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPlayer()
    }

    func setupPlayer(){
        player = AVPlayer(url: URL(string: video.url)!)
        player.seek(to: video.lastDuration)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0 , width: (self.view.frame.height), height: (self.view.frame.width))
        view.backgroundColor = .black
        self.view.layer.addSublayer(playerLayer)
        player.play()

        tap = UITapGestureRecognizer(target: self, action: #selector(self.touchedScreen(_:)))
        self.view.addGestureRecognizer(tap)

        createDoubleCheckTapGesture()

        videoController = VideoControlsView()
        videoController.frame = CGRect(x: 0, y: 0 , width: (self.view.frame.height), height: (self.view.frame.width))
        videoController.prepareScreenElements(delegate: self, player: player)
        view.addSubview(videoController)
        view.bringSubviewToFront(videoController)
    }

    @objc func touchedScreen(_ sender: UITapGestureRecognizer? = nil) {
        shouldControllerAppear(appear: nil)
    }

    func popThePage(){
        dismiss(animated: true, completion: nil)
    }

    func shouldControllerAppear(appear: Bool?){
        switch appear{
        case true:
            videoController.isHidden = false
        case false:
            videoController.isHidden = true
        case nil:
            videoController.isHidden = !videoController.isHidden
        case .some(_): break
        }
    }

    let leftView = UIView()
    let rightView = UIView()

//    MARK: DoubleTap Management(time jump) when Controller UI closed

    private func createDoubleCheckTapGesture(){
        leftView.frame = CGRect(x: 0, y: 0 , width: (self.view.frame.height / 2 - 125), height: (self.view.frame.width))
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(backward))
        leftTap.numberOfTapsRequired = 2
        view.addSubview(leftView)
        leftView.addGestureRecognizer(leftTap)
        tap.require(toFail: leftTap)

        rightView.frame = CGRect(x: (self.view.frame.height / 2 + 125), y: 0, width: (self.view.frame.height), height: (self.view.frame.width))
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(forward))
        rightTap.numberOfTapsRequired = 2
        view.addSubview(rightView)
        rightView.addGestureRecognizer(rightTap)
        tap.require(toFail: rightTap)
    }

    @objc func backward(){
        let wasHidden = videoController.isHidden
        videoController.backwardButtonTapped(0)
        shouldControllerAppear(appear: true)
        videoController.backBTN.isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            videoController.backBTN.isHighlighted = false
            if wasHidden {
                shouldControllerAppear(appear: false)
            }
        }
    }

    @objc func forward(){
        let wasHidden = videoController.isHidden
        videoController.forwardButtonTapped(0)
        shouldControllerAppear(appear: true)
        videoController.forBTN.isHighlighted = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            videoController.forBTN.isHighlighted = false
            if wasHidden {
                shouldControllerAppear(appear: false)
            }
        }
    }
}
