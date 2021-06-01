//
//  API.swift
//  AdoptLocal
//
//  Created by Morgan Duverney on 6/1/21.
//

import Foundation

enum API {
    static func getAnimals(with accessToken: AccessToken, completionHandler: @escaping (AnimalCollection) -> ()) {
        guard let url = URL(string: "https://api.petfinder.com/v2/animals?type=dog&page=2") else {
            print("URL is invalid")
            return
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        request.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error occurred while getting animals: \(error)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response")
                return
            }
            guard let data = data,
                  let animalCollection = try? JSONDecoder().decode(AnimalCollection.self, from: data) else {
                print("Failed to decode animal data")
                return
            }
            completionHandler(animalCollection)
        })
        .resume()
    }

    static func getAccessToken(completionHandler: @escaping (AccessToken) -> ()) {
        guard let url = URL(string: "https://api.petfinder.com/v2/oauth2/token"),
              let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String,
              let apiSecret = Bundle.main.infoDictionary?["API_SECRET"] as? String else {
            print("Failed to get url, api key or api secret")
            return
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringCacheData)
        request.httpMethod = "POST"
        
        let body: Data? = "grant_type=client_credentials&client_id=\(apiKey)&client_secret=\(apiSecret)".data(using: .utf8)
        request.httpBody = body
                
        URLSession.shared.dataTask(with: request, completionHandler: {data, response, error in
            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Unexpected response")
                return
            }
            guard let data = data,
                  let accessToken = try? JSONDecoder().decode(AccessToken.self, from: data) else {
                print("Failed to decode access token")
                return
            }
            completionHandler(accessToken)
        })
        .resume()
    }
}
