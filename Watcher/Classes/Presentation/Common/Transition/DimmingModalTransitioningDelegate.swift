//
//  CustomModalTransitioningDelegate.swift
//  Wathcer
//
//  Created by Петр Первухин on 13/02/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

final class DimmingModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {

    func presentationController(forPresented presented: UIViewController, 
                                presenting: UIViewController?, 
                                source: UIViewController) -> UIPresentationController? {
        let presentationController = DimmingModalPresentationController(presentedViewController: presented,
                                                                       presenting: presenting)
        return presentationController
    }
    
}
