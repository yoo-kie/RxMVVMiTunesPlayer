//
//  DetailViewModel.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/21.
//

import Foundation
import RxSwift
import RxCocoa

final class DetailViewModel: ViewModelType {
    
    struct Input {
        var track: AnyObserver<Track?>
    }
    
    struct Output {
        var image: Driver<UIImage?>
        var currentTimeText: Driver<String?>
        var durationText: Driver<String?>
        var titleText: Driver<String?>
    }
    
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private var _track: BehaviorSubject<Track?> = .init(value: nil)
    private var _image: BehaviorRelay<UIImage?> = .init(value: nil)
    private var _currentTimeText: BehaviorRelay<String?> = .init(value: nil)
    private var _durationText: BehaviorRelay<String?> = .init(value: nil)
    private var _titleText: BehaviorRelay<String?> = .init(value: nil)
    
    init() {
        input = Input(track: _track.asObserver())
        output = Output(
            image: _image.asDriver(),
            currentTimeText: _currentTimeText.asDriver(),
            durationText: _durationText.asDriver(),
            titleText: _titleText.asDriver()
        )
        
        _track.subscribe(
            onNext: { [weak self] track in
                guard let self = self, let track = track
                else { return }
                
                self._image.accept(UIImage(named: track.artworkUrl60))
                self._titleText.accept(track.trackName)
            }
        )
        .disposed(by: disposeBag)
    }
    
}
