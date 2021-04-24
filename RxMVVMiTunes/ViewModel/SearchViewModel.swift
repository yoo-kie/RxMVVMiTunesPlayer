//
//  ResultViewModel.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel: ViewModelType {
    
    struct Input {
        var term: AnyObserver<String?>
    }
    
    struct Output {
        var tracks: Driver<[Track]>
    }
    
    var disposeBag = DisposeBag()
    let input: Input
    let output: Output
    
    private let _term = BehaviorSubject<String?>(value: nil)
    private let _tracks: BehaviorRelay<[Track]> = .init(value: [])
    
    init() {
        input = Input(term: _term.asObserver())
        output = Output(tracks: _tracks.asDriver())
        
        _term.flatMap { term -> Observable<[Track]> in
            return Observable.create { observer -> Disposable in
                guard let term = term else { return Disposables.create() }
                        
                let endpoint = EndPoint.fetchEndPoint(of: .search, with: term)
                let response: Single<Result<ITunes, APIError>> = NetworkManager.instance.request(endpoint: endpoint)
                response.asObservable()
                    .subscribe(
                        onNext: { result in
                            switch result {
                            case .success(let iTunes):
                                observer.onNext(iTunes.results)
                            case .failure(let error):
                                observer.onError(error)
                            }
                        }
                    )
                    .disposed(by: self.disposeBag)
                
                return Disposables.create()
            }
        }
        .bind(to: _tracks)
        .disposed(by: disposeBag)
    }
    
}
