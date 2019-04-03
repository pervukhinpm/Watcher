//
//  ViewController+Alert.swift
//  Watcher
//
//  Created by Петр Первухин on 19/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit


extension UIViewController {
    
    /// Метод для показывания UIAlertController
    ///
    /// - Parameter title: заголовок
    /// - Parameter title: message сообщение для alert'а
    func showAlert(title: String = ls("error"), message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: ls("close"), style: .cancel) 
        alertController.addAction(closeAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
