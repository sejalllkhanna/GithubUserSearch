
import Foundation
import UIKit

class UserSearchViewModel: NSObject {
 
    private let githubUserWebService: WebServiceManager
    private var pageNumber = CommonSetting.startPageNumber
    private var users = [UserModel]()
    
    var isUserDataUpdated: Observable<Bool> = Observable(false)
    var isErrorOccured: Observable<CustomError?> = Observable(nil)

    init(githubUserWebService: WebServiceManager) {
        self.githubUserWebService = githubUserWebService
    }
}

extension UserSearchViewModel {
    
    private func clearUserData() {
        users.removeAll()
        isUserDataUpdated.value = true
    }
    
    func getGithubUser(searchText: String, pageNumber:Int = 1) {
        
        if searchText.count <= 0 {
            clearUserData()
            return
        }
        
        githubUserWebService.getGithubUsersBySearchText(searchText: searchText, pageNumber: pageNumber) { [weak self] (userArr, error) in
            
            if let error = error {
                self?.isErrorOccured.value = error
                return
            }
            
            if let allUsers = userArr, !allUsers.isEmpty {
                if pageNumber != CommonSetting.startPageNumber {
                    self?.users.append(contentsOf: allUsers)
                } else {
                    self?.users = allUsers
                    self?.pageNumber = CommonSetting.startPageNumber
                }
                self?.isUserDataUpdated.value = true
            } else {
                self?.isErrorOccured.value = CustomError.noResultFoundError
            }
        }
    }
    
    func getNextPageGithubUserForSerachText(searchText: String) {
        pageNumber += 1
        getGithubUser(searchText: searchText, pageNumber: pageNumber)
    }
    
//    func getGithubUserFromLocalCached(searchText: String) {
//
//        if searchText.count <= 0 {
//            clearUserData()
//            return
//        }
//        let newArr = users.filter { $0.login.lowercased().contains(searchText.lowercased())}
//        users = newArr
//        isUserDataUpdated.value = true
//    }
}


extension UserSearchViewModel: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        
            let userModelData = users[indexPath.row]
            cell.drawCell(userData: userModelData)
            cell.selectionStyle = .none
        
        return cell
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}

