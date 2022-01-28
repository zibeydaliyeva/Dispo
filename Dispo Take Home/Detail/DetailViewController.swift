import UIKit

class DetailViewController: BaseViewController {
    
    private var viewModel: DetailViewModel
    
    private let imgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(
            fontSize: 14,
            numLines: 0,
            alignment: .center)
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel(
            fontSize: 14,
            numLines: 0,
            alignment: .center)
        return label
    }()
    
    private let ratigLabel: UILabel = {
        let label = UILabel(
            fontSize: 14,
            numLines: 0,
            alignment: .center)
        return label
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            self.titleLabel,
            self.sourceLabel,
            self.ratigLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    init(id: String) {
        self.viewModel = DetailViewModel(id: id)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDetails()
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        view.addSubview(imgView)
        view.addSubview(textStackView)
    }
    
    private func setConstraints() {
        imgView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(150)
            make.centerX.equalTo(view)
        }
        
        textStackView.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(30)
            make.trailing.equalTo(-20)
            make.leading.equalTo(20)
        }
    }
    
    private func fetchDetails() {
        viewModel.getDetails(completion: { [weak self] error  in
            if let error = error {
                self?.errorHandler(error)
            } else {
                self?.setData()
            }
        })
    }
    
    private func setData() {
        titleLabel.text = "Title: " + (viewModel.title ?? "")
        sourceLabel.text = "Source: " + (viewModel.source ?? "")
        ratigLabel.text = "Rating: " + (viewModel.rating ?? "")
        imgView.kf.setImage(with: viewModel.imageURL)
    }

}
