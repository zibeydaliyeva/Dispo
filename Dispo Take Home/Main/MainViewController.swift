import UIKit

class MainViewController: BaseViewController {
    
    private var viewModel: MainViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = searchBar
        viewModel = MainViewModel()
        fetchTrendings()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "search gifs..."
        searchBar.delegate = self
        return searchBar
    }()
    
    private var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.backgroundColor = .clear
        collectionView.keyboardDismissMode = .onDrag
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: "MainViewCell")
        return collectionView
    }()
    
    
    private func fetchTrendings() {
        viewModel?.getTrendings(completion: { [weak self] error  in
            if let error = error {
                self?.errorHandler(error)
            } else {
                self?.collectionView.reloadData()
            }
        })
    }
}

// MARK: - UICollectionView data source
extension MainViewController:  UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.dataCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MainViewCell", for: indexPath) as? MainViewCell,
              let cellViewModel = viewModel?.getItem(at: indexPath.item)
        else { return UICollectionViewCell() }
        cell.configure(cellViewModel)
        return cell
    }
    
    
}

// MARK: - UICollectionView delegate 
extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellViewModel = viewModel?.getItem(at: indexPath.item) else { return }
        let detailViewController = DetailViewController(id: cellViewModel.id)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let fieldText = searchBar.text?.trim(),
              !fieldText.isEmpty
        else {
            viewModel?.queryExist = false
            collectionView.reloadData()
            return
        }
        
        viewModel?.queryExist = true
        viewModel?.getSearch(query: fieldText, completion: { [weak self] error in
            if let error = error {
                self?.errorHandler(error)
            } else {
                self?.collectionView.reloadData()
            }
        })
    }
}


