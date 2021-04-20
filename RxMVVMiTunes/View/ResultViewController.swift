//
//  ResultViewController.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import UIKit

final class ResultViewController: BaseViewController {
    
    enum Section: CaseIterable {
        case list
    }
    
    struct Item: Hashable {
        private let identifier = UUID()
        let title: String?
        let emoji: Emoji?
        let hasChildren: Bool
        
        init(emoji: Emoji? = nil, title: String? = nil, hasChildren: Bool = false) {
            self.emoji = emoji
            self.title = title
            self.hasChildren = hasChildren
        }
    }
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSource()
        applyInitialSnapshots()
    }

    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            let sectionType = Section.allCases[sectionIndex]
            
            switch sectionType {
            case .list:
                let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                section = NSCollectionLayoutSection.list(using: configuration, layoutEnvironment: layoutEnvironment)
            }
            
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    func configureDataSource() {
        let listCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Item> { (cell, indexPath, item) in
            var contentConfiguration = UIListContentConfiguration.valueCell()
            contentConfiguration.text = item.emoji?.text
            contentConfiguration.secondaryText = item.emoji?.title
            cell.contentConfiguration = contentConfiguration
        }
    
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            let sectionType = Section.allCases[indexPath.section]
            
            switch sectionType {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: item)
            }
        }
    }
    
    func applyInitialSnapshots() {
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot)
        
        var listSnapshot = NSDiffableDataSourceSectionSnapshot<Item>()
        listSnapshot.append(Emoji.Category.food.emojis.map { Item(emoji: $0) })
        dataSource.apply(listSnapshot, to: .list, animatingDifferences: false)
    }
    
}

extension ResultViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = DetailViewController.instantiate() else { return }
        present(vc, animated: true, completion: nil)
    }
    
}
