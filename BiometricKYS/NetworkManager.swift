//
//  NetworkManager.swift
//  BiometricKYS
//
//  Created by Tanirbergen Kaldibai on 13.08.2023.
//

import Alamofire

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
        
        /// session key
        
        let parameters: [String: Any] = ["api_key": key]
        
        /// request
        
        AF.request(BiometricConstants.createSessionURL,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default).response { [weak self] request in
            debugPrint(request)
            
            switch request.result {
            case let .success(data):
                do {
                    guard let data = data else { return }
                    
                    let result = try JSONDecoder().decode(BiometricResponseModel.self, from: data)
                    
                    self?.delegate?.didSetSessionToken(session: result)
                } catch {
                    print(error.localizedDescription)
                }
            case let .failure(error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
