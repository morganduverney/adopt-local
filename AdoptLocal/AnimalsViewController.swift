//
//  AnimalsViewController.swift
//  AdoptLocal
//
//  Created by Morgan Duverney on 6/1/21.
//

import UIKit

class AnimalsViewController: UIViewController {

    enum Section {
        case main
    }

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Animal>!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Animals"
        configureHierarchy()
        if let accessToken = API.shared.accessToken {
            API.shared.getAnimals(with: accessToken) { [weak self] animalCollection in
                DispatchQueue.main.async {
                    self?.configureDataSource(with: animalCollection.animals)
                }
            }
        } else {
            API.shared.getAccessToken { [weak self] accessToken in
                API.shared.accessToken = accessToken
                API.shared.getAnimals(with: accessToken) { animalCollection in
                    DispatchQueue.main.async {
                        self?.configureDataSource(with: animalCollection.animals)
                    }
                }
            }
        }
    }
}

extension AnimalsViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func configureDataSource(with animals: [Animal]) {
        let cellRegistration = UICollectionView.CellRegistration<AnimalCell, Animal> {
            (cell, indexPath, animal) in
            cell.typeLabel.text = animal.type
            cell.nameLabel.text = animal.name
            cell.ageGenderLabel.text = "\(animal.gender) - \(animal.age)"
            cell.descriptionLabel.text = animal.description
            cell.animalsSeparator = indexPath.item != animals.count - 1
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section,Animal>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Animal) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Animal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(animals)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func createLayout() -> UICollectionViewLayout {
        let estimatedHeight = CGFloat(100)
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                       subitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

