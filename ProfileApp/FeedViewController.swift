//
//  FeedViewController.swift
//  ProfileApp
//
//  Created by Александр Федоткин on 22.11.2023.
//

import UIKit
import Alamofire

class FeedViewController: UIViewController {
    @IBOutlet weak var feedTableView: UITableView!
    var responseResult = [ResponseResult?]()
    var responseResultLogo = [LogoResponseResult?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        ResponseResult().getData { result in
            switch result {
            case .success(_):
                do {
                    let res = try result.get()
                    for index in res {
                        self.responseResult.append(index)
                        print(self.responseResult)
                    }
                } catch {
                    AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: "Error response Data")
                }
                LogoResponseResult().getLogo { resultLogo in
                    switch resultLogo {
                    case .success(_):
                        do {
                            let res = try resultLogo.get()
                            self.responseResultLogo = res
                        } catch {
                            AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: error.localizedDescription)
                        }
                        self.feedTableView.reloadData()
                    case .failure(let error):
                        AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: error.localizedDescription)
                    }
                }
            case .failure(let failure):
                AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: failure.localizedDescription)
            }
        }

        // Do any additional setup after loading the view.
    }

}

//MARK: - setup tableView
extension FeedViewController : UITableViewDelegate, UITableViewDataSource {

    func setupTableView() {
        feedTableView.dataSource = self
        feedTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countOfPosts : Int = 0
        if responseResult[section]?.posts.count == nil {
            countOfPosts = 0
        } else {
            countOfPosts = responseResult[section]!.posts.count
        }
        print(countOfPosts)
        return countOfPosts
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var countOfUsers : Int = 0
        for index in responseResult {
            if index != nil {
                countOfUsers += 1
            }
        }
        return countOfUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTableView = tableView.dequeueReusableCell(withIdentifier: "dataCell", for: indexPath) as! NewDataTableViewCell
        guard let post = responseResult[indexPath.section] else { return cellTableView }
        print(post.posts[indexPath.row])
        cellTableView.textField.text = post.posts[indexPath.row]
        for index in responseResultLogo {
            if index!.id == post.id {
                let imageData = Data(base64Encoded: index!.logo)
                let image = UIImage(data: imageData!)
                let squareImage = CorrectImage.cropToSquare(image: image!)
                cellTableView.logoImageView.image = squareImage
            }
        }
        return cellTableView
    }
}
