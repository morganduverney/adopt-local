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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var searchQuery: String
    var dataSource: UICollectionViewDiffableDataSource<Section, Animal>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        displayAnimals()
    }
    
    init?(coder: NSCoder, searchQuery: String) {
        self.searchQuery = searchQuery
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension AnimalsViewController {
    func createLayout() -> UICollectionViewLayout {
        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(CGFloat(120)))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize,
                                                       subitem: item,
                                                       count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureCollectionView() {
        collectionView.collectionViewLayout = createLayout()
    }
    
    
    func configureDataSource(with animals: [Animal]) {
        dataSource = UICollectionViewDiffableDataSource<Section,Animal>(collectionView: collectionView) {
            (collectionView, indexPath, animal) -> AnimalCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AnimalCell.reuseIdentifer, for: indexPath) as? AnimalCell else { fatalError("Could not create new cell") }
            cell.typeLabel.text = animal.type
            cell.nameLabel.text = animal.name
            cell.genderAgeLabel.text = "\(animal.gender) - \(animal.age)"
            return cell
            
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Animal>()
        snapshot.appendSections([.main])
        snapshot.appendItems(animals)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func displayAnimals() {
        let loadingView = LoadingViewController()
        if let accessToken = API.shared.accessToken,
           accessToken.isValid() {
            displayLoadingIndicator(loadingView: loadingView)
            API.shared.getAnimals(with: accessToken, searchQuery: searchQuery) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let animalCollection):
                        self?.configureDataSource(with: animalCollection.animals)
                        self?.hideLoadingIndicator(loadingView: loadingView)
                    case .failure:
                        self?.hideLoadingIndicator(loadingView: loadingView)
                        self?.displayError()
                    }
                }
            }
        } else {
            displayLoadingIndicator(loadingView: loadingView)
            API.shared.getAccessToken { [weak self] accessToken in
                API.shared.accessToken = accessToken
                let searchQuery = self?.searchQuery ?? ""
                API.shared.getAnimals(with: accessToken, searchQuery: searchQuery) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let animalCollection):
                            self?.configureDataSource(with: animalCollection.animals)
                            self?.hideLoadingIndicator(loadingView: loadingView)
                        case .failure:
                            self?.hideLoadingIndicator(loadingView: loadingView)
                            self?.displayError()
                        }
                    }
                }
            }
        }
    }
    
    func displayLoadingIndicator(loadingView: LoadingViewController) {
        addChild(loadingView)
        loadingView.view.frame = view.frame
        view.addSubview(loadingView.view)
        loadingView.didMove(toParent: self)
    }
    
    func hideLoadingIndicator(loadingView: LoadingViewController) {
        loadingView.willMove(toParent: nil)
        loadingView.view.removeFromSuperview()
        loadingView.removeFromParent()
    }
    
    func displayError() {
        let errorLabel = UILabel()
        view.addSubview(errorLabel)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "No results found for your search, please try again."
        errorLabel.font = UIFont.preferredFont(forTextStyle: .body)
        errorLabel.textAlignment = .center
        
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

class LoadingViewController: UIViewController {
    var loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()
        view.addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

