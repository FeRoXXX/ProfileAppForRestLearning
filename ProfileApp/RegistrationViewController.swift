//
//  RegistrationViewController.swift
//  ProfileApp
//
//  Created by Александр Федоткин on 22.11.2023.
//

import UIKit
import PhotosUI
import Alamofire

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var correctLogoLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var correctTextLabel: UILabel!
    @IBOutlet weak var postsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizer()
        logoImageView.layer.cornerRadius = logoImageView.frame.width/2
        logoImageView.clipsToBounds = true

        // Do any additional setup after loading the view.
        
        print(User.sharedInstance)
    }
    
    @IBAction func saveDataClicked(_ sender: Any) {
        guard let image = logoImageView.image else {
            AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: "Логотип не загружен")
            return
        }
        RegistrationUser().uploadData(logoImageView: logoImageView.image!)  { result in
            switch result {
            case .success:
                print("Data uploaded successfully")
                self.performSegue(withIdentifier: "toFeedVCC", sender: nil)
            case .failure(let error):
                AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: error.localizedDescription)
            }
        }
        
    }
}

//MARK: - gestureRecognizer + picker image
extension RegistrationViewController : PHPickerViewControllerDelegate {
    
    func addGestureRecognizer() {
        logoImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeLogo))
        logoImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func changeLogo(){
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            guard item.canLoadObject(ofClass: UIImage.self) else { return }
            item.loadObject(ofClass: UIImage.self) { (image, error) in
                if let error = error {
                    AlertClass.makeAlert(on: self, titleInput: "Error", messageInput: error.localizedDescription)
                } else {
                    DispatchQueue.main.async {
                        if let image = image as? UIImage {
                            let squareImage = CorrectImage.cropToSquare(image: image)
                            self.logoImageView.image = squareImage
                            self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.width / 2
                            self.logoImageView.clipsToBounds = true
                        }
                    }
                }
            }
        }
    }
}

