import Foundation

enum Router {
    
    private static let baseUrl = "https://api.giphy.com/v1/gifs/"
    
    case getTrending
    case search(query: String)
    case getGIFById(id: String)
    
    var path: String {
        switch self {
        case .getTrending:
            return "trending"
        case .search:
            return "search"
        case .getGIFById(let id):
            return id
        }
    }
    
    var method: HTTPMethod {
      return .get
    }
    
    var parameters: [String : String] {
        var param: [String: String] = [
            "api_key": Constants.giphyApiKey
        ]
        switch self {
        case .getTrending:
            param["rating"] = "pg"
        case .search(let query):
            param["q"] = query
        default:
            break
        }
        return param
    }
    
    func request() throws -> URLRequest {
        let urlString = Router.baseUrl + path
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = urlComponents?.url else { throw ErrorService.incorrectUrl }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 5)
        request.addValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.httpMethod = method.value
        return request
    }
}

