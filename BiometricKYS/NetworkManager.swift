//
//  NetworkManager.swift
//  BiometricKYS
//
//  Created by Tanirbergen Kaldibai on 13.08.2023.
//

import Foundation

struct BiometricResponseModel: Decodable {
    let session_id: String
    let technologies: [String]
}

protocol NetworkManager {
    var delegate: DidObserveSession? { get set}
    func createSession(with key: String)
}

protocol DidObserveSession: AnyObject {
    func didSetSessionToken(session: BiometricResponseModel)
}

final class NetworkManagerImpl: NetworkManager {
    
    // Delegate
    
    weak var delegate: DidObserveSession?
    
    // Create session for Biometric
    
    func createSession(with key: String) {
        
        let url = URL(string: BiometricConstants.createSessionURL)!
        
        let urlRequest = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = "POST"
        
        let params: [String : Any] = ["api_key": key]
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        urlRequest.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) { (data, response, error) in
            guard let data = data, error == nil else {
                print("error=\(error ?? "Could not save Device Token" as! Error)")
                return
            }
            do {
                let tokenResponse = try JSONDecoder().decode(BiometricResponseModel.self, from: data)
                self.delegate?.didSetSessionToken(session: tokenResponse)
            } catch {
                print("json error: \(error)")
            }
        }
        task.resume()
    }
}
