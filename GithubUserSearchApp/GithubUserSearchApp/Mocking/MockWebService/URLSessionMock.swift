

import Foundation

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    
    var data: Data?
    var error: Error?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock {  [weak self] in
            completionHandler(self?.data, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil), self?.error)
        }
     }
    
}
