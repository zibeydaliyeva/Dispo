import UIKit
import Kingfisher

class MainViewCell: UICollectionViewCell {
    
    private let imgView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel(fontSize: 12)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(imgView)
        contentView.addSubview(titleLabel)
    }
    
    private func setConstraints() {
        imgView.snp.makeConstraints { make in
            make.width.height.equalTo(55)
            make.centerY.equalTo(self)
            make.leading.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.snp.trailing).offset(-20)
            make.leading.equalTo(imgView.snp.trailing).offset(10)
            make.centerY.equalTo(self)
        }
    }
    
    // MARK: - Set data
    func configure(_ viewModel: MainCellViewModel) {
        titleLabel.text = viewModel.title
        imgView.kf.setImage(with: viewModel.imageURL)
    }
}
