import Foundation

class MainViewModel {
    typealias Response = (ErrorService?) -> Void
    private var service: GifAPIClientProtocol
    private var trendingList: [GifObject] = []
    private var searchResults: [GifObject] = []
    var queryExist: Bool = false
    
    var dataCount: Int {
        return !queryExist ? trendingList.count : searchResults.count
    }
    
    init(_ service: GifAPIClientProtocol = GifAPIClient()) {
        self.service = service
    }
    
    func getTrendings(completion: @escaping Response) {
        service.getTrending { [weak self] result  in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if let trendings = data?.data {
                    self.trendingList = trendings
                }
                completion(.none)
            case .failure(let error):
                completion(error)
            }
        }
    }
    
    
    func getItem(at index: Int) -> MainCellViewModel? {
        guard dataCount > index else { return nil }
        let item = !queryExist ? trendingList[index] : searchResults[index]
        return MainCellViewModel(item: item)
    }
    
    
    func getSearch(query: String, completion: @escaping Response) {
        service.getSearch(query: query) { [weak self] result in
            switch result {
            case .success(let data):
                if let searchData = data?.data {
                    self?.searchResults = searchData
                }
                completion(.none)
            case .failure(let error):
                completion(error)
            }
        }
    }

}
