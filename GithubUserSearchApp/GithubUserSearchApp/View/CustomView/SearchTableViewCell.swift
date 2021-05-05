

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userThumbImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func drawCell(userData: UserModel)  {
        userNameLabel.text = userData.login
        ImageCacher.sharedImageCacher.loadImageFromUrl(urlString: userData.avatarURL, imageView: userThumbImage!)
    }
}
