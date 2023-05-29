//
//  IMFetchTokenTask.swift
//  IMKitWebchatDemoApp
//
//  Created by Howard Sun on 2023/5/30.
//

import Foundation


struct IMFetchTokenTaskResponse: Codable {
    let result: Result
    
    struct Result: Codable {
        let token: String
    }
}

class IMFetchTokenTask {
    var uid: String = ""
    var baseURL: String = "https://imkit-dev.funtek.io"
    var endpoint: String = "/auths/sign/v2"
    
    func perform(uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        self.uid = uid
        let fullURL = baseURL + endpoint
        guard let url = URL(string: fullURL) else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("fangho_imkit_0412_2018_001_clientkey", forHTTPHeaderField: "IM-CLIENT-KEY")
        let parameters = ["id": uid]
        do {
            let data = try JSONEncoder().encode(parameters)
            request.httpBody = data
        } catch {
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                print("No data in response.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(IMFetchTokenTaskResponse.self, from: data)
                completion(.success(response.result.token))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
