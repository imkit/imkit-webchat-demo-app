//
//  ViewController.swift
//  IMKitWebchatDemoApp
//
//  Created by Howard Sun on 2023/5/28.
//

import UIKit

class ViewController: UIViewController {
    
    let button = UIButton(type: .system)
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        button.setTitle("Go Chat", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        button.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        activityIndicator.isHidden = true
    }
    
    @objc func buttonTapped() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        button.setTitle(nil, for: .normal)
        fetchTokenAndRoomId { [weak self] roomId, token in
            DispatchQueue.main.async {
                self?.activityIndicator.isHidden = true
                self?.activityIndicator.endEditing(true)
                self?.button.setTitle("Go Chat", for: .normal)
                guard let roomId = roomId, let token = token else { return }
                let webViewController = WebViewController(roomId: roomId, token: token)
                self?.navigationController?.pushViewController(webViewController, animated: true)
            }
        }
    }
    
    func fetchTokenAndRoomId(completion: @escaping (String?, String?) -> Void) {
        let userDefaults = UserDefaults.standard
        
        // Fetch token and room ID from User Defaults
        if let roomId = userDefaults.string(forKey: "roomId"),
           let token = userDefaults.string(forKey: "token") {
            completion(roomId, token)
            return
        }
        
        let uid = generateRandomString(length: 16)
        print(uid)
        IMFetchTokenTask().perform(uid: uid) { result in
            switch result {
            case .success(let token):
                print("Received token: \(token)")
                
                // Create a direct chat room
                let task = IMCreateDirectChatTask()
                let coverURL: URL? = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/ChatGPT_logo.svg/1200px-ChatGPT_logo.svg.png")
                let invitee: String = "ho2"
                
                task.perform(token: token, coverURL: coverURL, invitee: invitee) { result in
                    switch result {
                    case .success(let response):
                        print("Created room: \(response.result._id)")
                        // Store token and room ID in User Defaults
                        userDefaults.set(token, forKey: "token")
                        userDefaults.set(response.result._id, forKey: "roomId")
                        
                        // Fetch token and room ID from User Defaults after they were possibly set above
                        let roomId = userDefaults.string(forKey: "roomId") ?? ""
                        let token = userDefaults.string(forKey: "token") ?? ""
                        
                        completion(roomId, token)
                    case .failure(let error):
                        print("An error occurred: \(error)")
                        completion(nil, nil)
                    }
                }
            case .failure(let error):
                print("An error occurred: \(error)")
                completion(nil, nil)
            }
        }
    }
    
    func generateRandomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
