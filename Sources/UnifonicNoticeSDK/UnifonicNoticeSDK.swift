import Alamofire
import UserNotifications
import UIKit

public class UnifonicNoticeSDK: NSObject, UIApplicationDelegate {
    
    public static let shared = UnifonicNoticeSDK()
    
    override private init() {}
    
    public func register(appId: String, completion: @escaping (_ sdkToken: String?, _ error: String?) -> ()) {
        let storedAppId = UserDefaults.standard.string(forKey: Constants.kAppIdKey)
        if storedAppId == appId {
            if let storedToken = UserDefaults.standard.string(forKey: Constants.kTokenKey) {
                print("Returning stored token")
                completion(storedToken, nil)
            }
        }
        else {
            print("Creating a new one")
            let request = AF.request(
                Constants.kBaseUrl + "/" + Constants.kApiVersion + "/" + Constants.kRegisterAPI,
                method: HTTPMethod.post,
                parameters: [ "app_id": appId ],
                encoding: JSONEncoding.default
            )
            request.responseJSON { response in
                print(request.cURLDescription())
                switch response.result {
                case .success(let JSON):
                    let response = JSON as! NSDictionary
                    if let error = response.object(forKey: "error") {
                        completion(nil, error as? String)
                    }
                    else {
                        if let sdkToken = response.object(forKey: Constants.kTokenKey) as? String {
                            UserDefaults.standard.set(appId, forKey: Constants.kAppIdKey)
                            UserDefaults.standard.set(sdkToken, forKey: Constants.kTokenKey)
                            completion(sdkToken, nil)
                        }
                        else {
                            completion(nil, nil)
                        }
                    }
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                }
            }
        }
    }
    
    public func saveToken(identifier: String, pushToken: String, completion: @escaping (_ status: Bool, _ error: String?) -> ()) {
        let storedAppId = UserDefaults.standard.string(forKey: Constants.kAppIdKey)
        let storedToken = UserDefaults.standard.string(forKey: Constants.kTokenKey)
        if (storedAppId == nil) {
            completion(false, "No app id registered")
        }
        let request = AF.request(
            Constants.kBaseUrl + "/" + Constants.kApiVersion + "/" + Constants.kBindingAPI,
            method: HTTPMethod.post,
            parameters: [
                "address": pushToken,
                "identifier": identifier,
                "type": "apn"
            ],
            encoding: JSONEncoding.default,
            headers: [
                "Authorization": "Bearer \(storedToken!)",
                "x-notice-app-id": storedAppId!
            ] as HTTPHeaders
        )
        request.responseJSON { response in
            print(request.cURLDescription())
            switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                if let error = response.object(forKey: "error") {
                    completion(false, error as? String)
                }
                else {
                    UserDefaults.standard.set(pushToken, forKey: "address")
                    completion(true, nil)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    public func markNotificationAsRead(messageId: String, completion: @escaping (_ status: Bool, _ error: String?) -> ()) {
        let storedAppId = UserDefaults.standard.string(forKey: Constants.kAppIdKey)
        let storedToken = UserDefaults.standard.string(forKey: Constants.kTokenKey)
        if (storedAppId == nil) {
            completion(false, "No app id registered")
        }
        let request = AF.request(
            Constants.kBaseUrl + "/" + Constants.kApiVersion + "/" + Constants.kBindingAPI,
            method: HTTPMethod.post,
            parameters: [
                "message_id": messageId
            ],
            encoding: JSONEncoding.default,
            headers: [
                "Authorization": "Bearer \(storedToken!)",
                "x-notice-app-id": storedAppId!
            ] as HTTPHeaders
        )
        request.responseJSON { response in
            print(request.cURLDescription())
            switch response.result {
            case .success(let JSON):
                let response = JSON as! NSDictionary
                if let error = response.object(forKey: "error") {
                    completion(false, error as? String)
                }
                else {
                    completion(true, nil)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
}
