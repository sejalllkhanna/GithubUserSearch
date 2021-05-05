
import Foundation


class WebServiceManager {
    
    private let session: URLSession
    
    // By using a default argument (in this case .shared) we can add dependency
    // injection without making our app code more complicated.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getGithubUsersBySearchText(searchText: String, pageNumber: Int, completion: @escaping ([UserModel]?, CustomError?)->()) {
        
        let urlString = "\(HTTPUrl.githubBaseUrl)q=\(searchText)&page=\(pageNumber)&per_page=\(CommonSetting.perPage)"
        debugPrint("UrlString = \(urlString)")
        guard let url = URL(string: urlString) else { return }

        session.dataTask(with: URLRequest(url: url)) { (responseData, response, error) in
            
            if error != nil || responseData == nil {
                completion(nil,CustomError.httpResponseError)
                debugPrint("Client error!")
                return
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                debugPrint("Server error!")
                completion(nil,CustomError.httpServerError)
                return
            }
            guard let data = responseData else {
                completion(nil, CustomError.dataError)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let responseVal: UserRespModel = try decoder.decode(UserRespModel.self, from: data)
                let usersArr: [UserModel] = responseVal.items.map{UserModel(login:$0.login,avatarURL:$0.avatarURL)}
                 completion(usersArr,nil)
            } catch {
                debugPrint("JSON error: \(error.localizedDescription)")
                completion(nil,CustomError.jsonDecoingError)
            }
            }.resume()
    }
}
