//
//  PostDetailsViewController.swift
//  ProfileApp
//
//  Created by Александр Федоткин on 28.11.2023.
//

import UIKit
import Alamofire

class PostDetailsViewController: UIViewController {

    @IBOutlet weak var postData: UITextView!
    var postArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NewPost().getPosts { result in
            switch result {
            case .success(let resultRequestPosts):
                print("success \(resultRequestPosts)")
                self.postArray = resultRequestPosts.posts
            case .failure(_):
                print("error")
            }
        }
    }
    
    @IBAction func savePostClicked(_ sender: Any) {
        guard let post = postData.text else {
            AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: "Введите текст поста")
            return
        }
        NewPost().savePost(postArray: postArray, postData: post) { result in
            switch result {
            case .success(_):
                print("Success")
                self.performSegue(withIdentifier: "toUpdateMyProfile", sender: nil)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
}

