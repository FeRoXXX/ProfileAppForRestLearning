//
//  AlertClass.swift
//  ProfileApp
//
//  Created by Александр Федоткин on 04.12.2023.
//

import UIKit

final class AlertClass {
    
    static func makeAlert(on vc: UIViewController, titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        vc.present(alert, animated: true)
    }
}
