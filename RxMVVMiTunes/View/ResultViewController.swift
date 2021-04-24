//
//  ResultViewController.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import UIKit
import RxSwift
import RxCocoa

final class ResultViewController: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    var viewModel: SearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(
            UINib(nibName: "ResultTableViewCell", bundle: .main),
            forCellReuseIdentifier: "ResultTableViewCell"
        )
        
        bind()
    }
    
    static func instantiate(viewModel: SearchViewModel) -> ResultViewController? {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        
        guard let viewController = storyboard.instantiateViewController(identifier: "ResultViewController") as? ResultViewController
        else { return nil }
        
        viewController.viewModel = viewModel
    
        return viewController
    }
    
    private func bind() {
        viewModel.output.tracks
            .asDriver()
            .drive(tableView.rx.items(cellIdentifier: "ResultTableViewCell")) { row, track, cell in
                guard let cell = cell as? ResultTableViewCell else { return }
                cell.configureCell(with: track)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Track.self)
            .subscribe(
                onNext: { [weak self] track in
                    guard let self = self,
                          let vc = DetailViewController.instantiate(viewModel: DetailViewModel())
                    else { return }
                    
                    Observable<Track>.just(track)
                        .bind(to: vc.viewModel.input.track)
                        .disposed(by: self.disposeBag)
                    
                    self.present(vc, animated: true, completion: nil)
                }
            )
            .disposed(by: disposeBag)
    }
    
}
