//
//  DetailViewController.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa

final class DetailViewController: BaseViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var seekBar: UISlider!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playbackButton: UIButton!
    
    private let disposeBag = DisposeBag()
    var track: Track?
    var avPlayer: AVPlayer = AVPlayer()
    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configurePlayer()
    }

    static func instantiate(viewModel: DetailViewModel) -> DetailViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        
        guard let viewController = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController
        else { return nil }
        
        viewController.viewModel = viewModel
    
        return viewController
    }
    
    private func bind() {
        viewModel.output.image
            .asDriver()
            .drive(imageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output.titleText
            .asDriver()
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func configurePlayer() {
        guard let previewUrl = track?.previewUrl,
              let url = URL(string: previewUrl)
        else { return }
        
        let avPlayerItem: AVPlayerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: avPlayerItem)
        avPlayer.play()
    }
    
}
