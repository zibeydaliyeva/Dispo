import UIKit

// For test coverage
protocol GifAPIClientProtocol {
    typealias ResponseResult<T: Decodable> = (Result<T, ErrorService>) -> Void
    func getTrending(completion: @escaping ResponseResult<APIListResponse?>)
    func getSearch(query: String, completion: @escaping ResponseResult<APIListResponse?>)
    func getGifById(id: String, completion: @escaping ResponseResult<APISingleResponse?>)
}

class GifAPIClient: GifAPIClientProtocol {
    
    private var urlSession: URLSession
    
    // MARK: - Initializer
    init(with urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func getTrending(completion: @escaping ResponseResult<APIListResponse?>) {
        return self.request(router: Router.getTrending, completion: completion)
    }
    
    func getSearch(query: String, completion: @escaping ResponseResult<APIListResponse?>) {
        return self.request(router: Router.search(query: query), completion: completion)
    }
    
    func getGifById(id: String, completion: @escaping ResponseResult<APISingleResponse?>) {
        return self.request(router: Router.getGIFById(id: id), completion: completion)
    }
}



extension GifAPIClient {

    private func request<T: Decodable>(router: Router, completion: @escaping (Result<T, ErrorService>) -> Void) {
        do {
            let task = try urlSession.dataTask(with: router.request()) { (data, response, error) in
                DispatchQueue.main.async {
                    if error != nil {
                        completion(.failure(.connectionError))
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(.failure(.emptyResponseError))
                        return
                    }
                    guard (200...299).contains(httpResponse.statusCode) else {
                        let error: ErrorService
                        switch httpResponse.statusCode {
                        case 404:
                            error = .pageNotFound
                        case 500:
                            error = .serverError
                        default: error = .defaultError("Wrong response from server")
                        }
                        completion(.failure(error))
                        return
                    }

                    guard let data = data else {
                        completion(.failure(.noData))
                        return
                    }

                    do {
                        let decodedData = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch {
                        completion(.failure(.parseError))
                    }
                }

            }
            task.resume()
        } catch let error {
            completion(.failure(.defaultError(error.localizedDescription)))
        }
    }
    
}
