//
//  DetailViewModel.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/21.
//

import Foundation
import AVKit
import RxSwift
import RxCocoa

final class DetailViewModel: ViewModelType {
    
    struct Input {
        var track: AnyObserver<Track?>
        // slider 무브
    }
    
    struct Output {
        var image: Driver<UIImage?>
        var currentTime: Driver<Int?>
        var duration: Driver<Int?>
        var titleText: Driver<String?>
        var avPlayerItem: Observable<AVPlayerItem?>
    }
    
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private var _track: BehaviorSubject<Track?> = .init(value: nil)
    private var _image: BehaviorRelay<UIImage?> = .init(value: nil)
    private var _currentTime: BehaviorRelay<Int?> = .init(value: nil)
    private var _duration: BehaviorRelay<Int?> = .init(value: nil)
    private var _titleText: BehaviorRelay<String?> = .init(value: nil)
    private var _avPlayerItem: BehaviorRelay<AVPlayerItem?> = .init(value: nil)
    
    init() {
        input = Input(track: _track.asObserver())
        output = Output(
            image: _image.asDriver(),
            currentTime: _currentTime.asDriver(),
            duration: _duration.asDriver(),
            titleText: _titleText.asDriver(),
            avPlayerItem: _avPlayerItem.asObservable()
        )
        
        _track.subscribe(
            onNext: { [weak self] track in
                guard let self = self, let track = track
                else { return }
                
                self._image.accept(UIImage(named: track.artworkUrl60))
                self._titleText.accept(track.trackName)
                
                guard let url = URL(string: track.previewUrl)
                else { return }
                
                let avPlayerItem: AVPlayerItem = AVPlayerItem(url: url)
                self._avPlayerItem.accept(avPlayerItem)
            }
        )
        .disposed(by: disposeBag)
    }
    
}
