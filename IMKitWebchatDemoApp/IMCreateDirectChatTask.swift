//
//  IMCreateDirectChatTask.swift
//  IMKitWebchatDemoApp
//
//  Created by Howard Sun on 2023/5/30.
//

import Foundation

struct IMCreateDirectChatTaskResponse: Codable {
    let result: Result
    
    struct Result: Codable {
        let _id: String
    }
}

class IMCreateDirectChatTask {
    var baseURL: String = "https://imkit-dev.funtek.io"
    var endpoint: String = "/rooms/createAndJoin"
    
    private var token: String = ""
    private var roomId: String?
    private var roomName: String?
    private var coverURL: URL?
    private var description: String?
    private var invitee: String?
    private var isSystemMessageEnabled = false
    
    func perform(token: String, roomId: String? = nil, roomName: String? = nil, coverURL: URL? = nil, description: String? = nil, invitee: String, isSystemMessageEnabled: Bool = false, completion: @escaping (Result<IMCreateDirectChatTaskResponse, Error>) -> Void) {
        self.token = token
        self.roomId = roomId
        self.roomName = roomName
        self.coverURL = coverURL
        self.description = description
        self.invitee = invitee
        self.isSystemMessageEnabled = isSystemMessageEnabled
        
        let fullURL = baseURL + endpoint
        guard let url = URL(string: fullURL) else {
            print("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("fangho_imkit_0412_2018_001_clientkey", forHTTPHeaderField: "IM-CLIENT-KEY")
        request.setValue(token, forHTTPHeaderField: "IM-Authorization")
        
        let parameters: [String: Any] = [
            "_id": roomId ?? "",
            "name": roomName ?? "",
            "cover": coverURL?.absoluteString ?? "",
            "description": description ?? "",
            "invitee": invitee,
            "systemMessage": isSystemMessageEnabled,
            "roomType": "direct",
            "webhook": "https://imkit.nexdoor.cc"
        ]
        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
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
                let response = try decoder.decode(IMCreateDirectChatTaskResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
