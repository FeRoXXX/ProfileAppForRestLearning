//
//  YourProfileViewController.swift
//  ProfileApp
//
//  Created by Александр Федоткин on 22.11.2023.
//

import UIKit
import Alamofire
class YourProfileViewController: UIViewController {
    
    @IBOutlet weak var namePageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoImageLabel: UIImageView!
    @IBOutlet weak var publicationLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    
    var postsArray = [String]()
    var resultPostRequestForTableView : ResponseResult?
    var logoUser : UIImage?
    let currentUser = User.sharedInstance.user?.email
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let userEmail = currentUser {
            self.emailLabel.text = "e-mail: \(userEmail)"
        }

        LogoResponseResult().getProfileImage { result in
            switch result {
            case .success(let res):
                if let logoData = Data(base64Encoded: res.logo) {
                    if let logoImage = UIImage(data: logoData) {
                        let squareImage = CorrectImage.cropToSquare(image: logoImage)
                        self.logoImageLabel.image = squareImage
                        self.logoImageLabel.layer.cornerRadius = self.logoImageLabel.frame.size.width / 2
                        self.logoImageLabel.clipsToBounds = true
                        self.logoUser = squareImage
                        self.profileTableView.reloadData()
                    }
                } else {
                    AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: "Ошибка при получении данных")
                }
            case .failure(let error):
                AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: error.localizedDescription)
            }
        }
        
        ResponseResult().getProfileData { result in
            switch result {
            case .success(let resultRequestPosts):
                print("success \(resultRequestPosts)")
                self.postsArray.removeAll()
                self.resultPostRequestForTableView = resultRequestPosts
                self.postsArray = resultRequestPosts.posts
                self.profileTableView.reloadData()
            case .failure(let error):
                AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: error.localizedDescription)
            }
        }
        setup()
    }

    @IBAction func newPostClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toNewPost", sender: nil)
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        User.sharedInstance.user = nil
        User.sharedInstance.accessToken = ""
        UserData.sharedInstanceUserData.id = 0
        UserData.sharedInstanceUserData.email = ""
        self.performSegue(withIdentifier: "toSignInVC", sender: nil)
    }
    
    
}

//MARK: - Setup tableView
extension YourProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    func setup() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! NewDataTableViewCell
        cell.textField.text = postsArray[indexPath.row]
        cell.logoImageView.image = logoUser
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsArray.count
    }
}
