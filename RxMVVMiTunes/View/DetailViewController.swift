//
//  DetailViewController.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import UIKit
import AVKit

final class DetailViewController: BaseViewController {
    
    var track: Track?
    var avPlayer: AVPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePlayer()
    }

    static func instantiate() -> DetailViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        
        guard let viewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        else { return nil }
    
        return viewController
    }
    
    func configurePlayer() {
        guard let previewUrl = track?.previewUrl,
              let url = URL(string: previewUrl)
        else { return }
        
        let avPlayerItem: AVPlayerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: avPlayerItem)
        avPlayer.play()
    }
    
}
