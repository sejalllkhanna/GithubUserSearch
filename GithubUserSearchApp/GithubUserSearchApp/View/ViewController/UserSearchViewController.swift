
import UIKit

class UserSearchViewController: UIViewController {
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var noUserFoundView: UIView!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
        
    public var viewModel = UserSearchViewModel(githubUserWebService: WebServiceManager())
    let spinner = UIActivityIndicatorView(style: .gray)
    let searchSpinner = UIActivityIndicatorView(style: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.addSubview(searchSpinner)
        userTableView.dataSource = viewModel
        
        initViewModelSetup()
        initAccessIdentifier()
    }
    
    func initAccessIdentifier()  {
        userSearchBar.accessibilityIdentifier = "UserSearchBar"
        userTableView.accessibilityIdentifier = "UserSearchBar.Tableview"
        noUserFoundView.accessibilityIdentifier = "NoUserFound.view"
        errorMessageView.accessibilityIdentifier = "ErrorMessgae.view"
    }
    
    private func initViewModelSetup()  {
        viewModel.isUserDataUpdated.bind{ [weak self] (isFetchedData) in
            if isFetchedData {
                self?.refreshTableView()
            }
        }
        
        viewModel.isErrorOccured.bind{ [weak self] (error) in
            guard let error = error else { return }
            switch error {
            case CustomError.httpResponseError, CustomError.jsonDecoingError, CustomError.dataError, CustomError.httpServerError:
                self?.showHttpError(show: true)
            case CustomError.noResultFoundError:
                self?.showNoUserData()
            }
        }
    }
    private func refreshTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.noUserFoundView.isHidden = true
            self?.userTableView.isHidden = false
            self?.userTableView.reloadData()
            self?.stopAnimatingSpinner()
        }
    }
    
    private func showNoUserData() {
        DispatchQueue.main.async { [weak self] in
            self?.noUserFoundView.isHidden = false
            self?.userTableView.isHidden = true
            self?.stopAnimatingSpinner()
        }
    }
    
    private func stopAnimatingSpinner() {
        
        if searchSpinner.isAnimating {
             searchSpinner.stopAnimating()
             searchSpinner.hidesWhenStopped = true
        }
        if spinner.isAnimating {
            spinner.stopAnimating()
            spinner.hidesWhenStopped = true
        }
    }
    
    func showHttpError(show: Bool = false) {
        DispatchQueue.main.async {  [weak self] in
            UIView.animate(withDuration: 0.3, animations: {
                self?.errorMessageView.alpha = 0.5
            }) { (finished) in
                self?.errorMessageView.isHidden = !show
            }
        }
        
        if show {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                self?.errorMessageView.isHidden = true
            }
        }
    }
}

extension UserSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchSpinner.frame = UIScreen.main.bounds
        searchSpinner.startAnimating()
        viewModel.getGithubUser(searchText: searchText)
    }
}

extension UserSearchViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if userTableView.contentOffset.y >= (userTableView.contentSize.height - userTableView.frame.size.height) {
            spinner.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 60)
            userTableView.tableFooterView = spinner
            if let searchText = userSearchBar.text, !spinner.isAnimating {
                spinner.startAnimating()
                viewModel.getNextPageGithubUserForSerachText(searchText: searchText)
            }
        }
    }
}
