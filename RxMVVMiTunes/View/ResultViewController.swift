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
    var searchViewModel: SearchViewModel!
    
    static func instantiate(viewModel: SearchViewModel) -> ResultViewController? {
        let storyboard = UIStoryboard.init(name: StoryBoard.Main.rawValue, bundle: .main)
        
        guard let viewController = storyboard.instantiateViewController(
                identifier: ResultViewController.className
            ) as? ResultViewController
        else { return nil }
        
        viewController.searchViewModel = viewModel
    
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bind()
    }
    
    private func configureTableView() {
        tableView.register(
            UINib(
                nibName: ResultTableViewCell.className,
                bundle: .main
            ),
            forCellReuseIdentifier: ResultTableViewCell.className
        )
    }
    
    private func bind() {
        searchViewModel.output.tracks
            .asDriver()
            .drive(tableView.rx.items(
                    cellIdentifier: ResultTableViewCell.className)
            ) { row, track, cell in
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
