//
//  Error.swift
//  WhatCanIEat
//
//  Created by Jérôme Guèrin on 29/07/2020.
//  Copyright © 2020 Jérôme Guèrin. All rights reserved.
//

import UIKit

enum ApplicationError: String {
    case network = "An network error has occured. Please retry later. It's possible your ingredients find nothing."
}

extension UIViewController {
    func sendAlert(_ error: ApplicationError) {
        let alert = UIAlertController(title: "Error", message: error.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
