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
import MediaPlayer

final class DetailViewController: BaseViewController {
    
    @IBOutlet var wrapperView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var seekBar: UISlider!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var playbackButton: UIButton!
    @IBOutlet var volumeSlider: UISlider!
    private var mpVolumeSlider: UISlider!
    
    private let disposeBag = DisposeBag()
    private var avPlayer: AVPlayer = AVPlayer()
    var viewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        configureVolumeView()
        bind()
    }

    static func instantiate(viewModel: DetailViewModel) -> DetailViewController? {
        let storyboard = UIStoryboard.init(name: StoryBoard.Main.rawValue, bundle: .main)
        
        guard let viewController = storyboard.instantiateViewController(identifier: DetailViewController.className) as? DetailViewController
        else { return nil }
        
        viewController.viewModel = viewModel
    
        return viewController
    }
    
    private func setUI() {
        wrapperView.layer.cornerRadius = 12
        wrapperView.layer.shadowColor = UIColor.darkGray.cgColor
        wrapperView.layer.shadowOffset = CGSize(width: 5, height: 5)
        wrapperView.layer.shadowRadius = 12.0
        wrapperView.layer.shadowOpacity = 0.9
        
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        
        seekBar.setThumbImage(UIImage.init(), for: .normal)
    }
    
    private func configureVolumeView() {
        volumeSlider.minimumValue = 0.0
        volumeSlider.maximumValue = 1.0
        
        let volumeView = MPVolumeView()
        mpVolumeSlider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        mpVolumeSlider.value = AVAudioSession.sharedInstance().outputVolume
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
        
        viewModel.output.avPlayerItem
            .subscribe(
                onNext: { [weak self] item in
                    guard let self = self, let item = item
                    else { return }
                    
                    self.avPlayer.replaceCurrentItem(with: item)
                }
            )
            .disposed(by: disposeBag)
            
        playbackButton.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    guard let self = self else { return }
                    if !self.playbackButton.isSelected {
                        self.avPlayer.play()
                    } else {
                        self.avPlayer.pause()
                    }
                    
                    self.playbackButton.isSelected.toggle()
                }
            )
            .disposed(by: disposeBag)
        
        Observable<Int>.interval(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] _ in
                    guard let self = self,
                          let item = self.avPlayer.currentItem
                    else { return }

                    self.seekBar.value = Float(CMTimeGetSeconds(self.avPlayer.currentTime()) / CMTimeGetSeconds(item.duration))
                    
                    self.currentTimeLabel.text = "00:\(Int(CMTimeGetSeconds(self.avPlayer.currentTime())))"
                    
                    if self.avPlayer.currentItem!.status == .readyToPlay {
                        self.durationLabel.text = "00:\(Int(CMTimeGetSeconds(item.duration)))"
                    }
                }
            )
            .disposed(by: disposeBag)
        
        volumeSlider.rx.value
            .bind(to: mpVolumeSlider.rx.value)
            .disposed(by: disposeBag)
        
        mpVolumeSlider.rx.value
            .bind(to: volumeSlider.rx.value)
            .disposed(by: disposeBag)
    }
    
}
