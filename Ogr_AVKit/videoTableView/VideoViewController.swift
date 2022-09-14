//
//  VideoViewController.swift
//  Ogr_AVKit
//
//  Created by teyhan.uslu on 3.08.2022.
//

import UIKit
import AVKit
import AVFoundation

class VideoViewController: UIViewController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .portrait }

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

extension VideoViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoTableViewCell
        cell.prepareCell(rowAt: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideoScreenViewController") as! VideoScreenViewController
        vc.video = videos[indexPath.row]
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
