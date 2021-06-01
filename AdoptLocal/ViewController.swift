//
//  ViewController.swift
//  AdoptLocal
//
//  Created by Morgan Duverney on 6/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    var accessToken: AccessToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateAnimals()
    }
    
    private func updateAnimals() {
        if let accessToken = accessToken {
            print("Found access token!")
            API.getAnimals(with: accessToken) { animalCollection in
                print(animalCollection.animals)
            }
        } else {
            print("No access token found")
            API.getAccessToken { [weak self] accessToken in
                self?.accessToken = accessToken
                API.getAnimals(with: accessToken) { animalCollection in
                    print(animalCollection.animals)
                }
            }
        }
    }
}

