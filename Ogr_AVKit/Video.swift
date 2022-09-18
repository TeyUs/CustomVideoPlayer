//
//  Video.swift
//  Ogr_AVKit
//
//  Created by teyhan.uslu on 6.09.2022.
//

import Foundation
import CoreMedia

class Video{
    let url: String
    let name: String
    let imageUrl: String
    var lastDuration: CMTime {
        get{
            getTime()
        }set{
            saveTime(time: newValue)
        }
    }

    internal init(url: String, name: String, imageUrl: String) {
        self.url = url
        self.name = name
        self.imageUrl = imageUrl
    }
}

var videos: [Video] = [Video(url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4", name: "Big Buck Bunny", imageUrl: "images/BigBuckBunny.jpg"),
                       Video(url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4", name: "Elephant Dream", imageUrl: "images/ElephantsDream.jpg"),
                       Video(url: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4", name: "For Bigger Blazes", imageUrl: "images/ForBiggerBlazes.jpg")]

extension Video{
    private func getTime() -> CMTime{
        let time = UserDefaults.standard.integer(forKey: self.name)
        let cmTime = CMTimeMake(value: Int64(time), timescale: 1)
        if CMTIME_IS_INVALID(cmTime){
            return CMTimeMake(value: 0, timescale: 1)
        }
        return cmTime
    }

    private func saveTime(time: CMTime){
        UserDefaults.standard.set(CMTimeGetSeconds(time), forKey: self.name)
    }

    func resetTime(){
        self.lastDuration = CMTimeMake(value: 0, timescale: 1)
    }
}
