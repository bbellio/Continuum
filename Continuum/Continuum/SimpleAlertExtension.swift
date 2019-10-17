//
//  SimpleAlertExtension.swift
//  Continuum
//
//  Created by Bethany Wride on 10/17/19.
//  Copyright © 2019 Bethany Bellio. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentSimpleAlertWith(title: String, message: String?) {
        let alert = UIAlertController()
        let okayAction = UIAlertAction(title: "Okay", style: .cancel)
        alert.addAction(okayAction)
        present(alert, animated: true)
    }
}
