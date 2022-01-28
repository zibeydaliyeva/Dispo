import Foundation

class DetailViewModel {
    typealias Response = (ErrorService?) -> Void
    private var service: GifAPIClientProtocol
    private var detailGif: GifObject?
    private let id: String
    
    var title: String? {
        return detailGif?.title
    }
    
    var imageURL: URL? {
        return detailGif?.images.fixed_height.url
    }
    
    var source: String? {
        return detailGif?.source_tld
    }
    
    var rating: String? {
        return detailGif?.rating
    }
    
    init(_ service: GifAPIClientProtocol = GifAPIClient(), id: String) {
        self.service = service
        self.id = id
    }
    
    func getDetails(completion: @escaping Response) {
        service.getGifById(id: id) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let detailGif = data?.data {
                    self.detailGif = detailGif
                }
                completion(.none)
            case .failure(let error):
                completion(error)
            }
        }
    }
}
