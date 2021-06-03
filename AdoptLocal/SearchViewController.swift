//
//  SearchViewController.swift
//  AdoptLocal
//
//  Created by Morgan Duverney on 6/2/21.
//

import UIKit
import SwiftUI

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    var searchQuery: String?
    
    @IBSegueAction func showSearchResults(_ coder: NSCoder) -> AnimalsViewController? {
        return AnimalsViewController(coder: coder, searchQuery: searchQuery ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = searchTextField.text else { return }
        searchQuery = text
        performSegue(withIdentifier: "showSearchResults", sender: self)
    }
}
