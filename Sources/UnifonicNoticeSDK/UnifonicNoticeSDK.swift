import Alamofire
import UserNotifications

public enum NotificationReadType {
    case read
    case received
}

public class UnifonicNoticeSDK: NSObject {
    
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
    
    public func disableNotification(identifier: String, completion: @escaping (_ status: Bool, _ error: String?) -> ()) {
        guard let storedAppId = UserDefaults.standard.string(forKey: Constants.kAppIdKey),
              let storedToken = UserDefaults.standard.string(forKey: Constants.kTokenKey),
              let pushToken = UserDefaults.standard.string(forKey: "address") else {
            completion(true, "Already disabled")
            return
        }
        let request = AF.request(
            Constants.kBaseUrl + "/" + Constants.kApiVersion + "/" + Constants.kUpdateStatusAPI,
            method: HTTPMethod.post,
            parameters: [
                "address": pushToken,
                "status": "disabled"
            ],
            encoding: JSONEncoding.default,
            headers: [
                "Authorization": "Bearer \(storedToken)",
                "x-notice-app-id": storedAppId
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
                    UserDefaults.standard.removeObject(forKey: "address")
                    print("Removed")
                    completion(true, nil)
                }
            case .failure(let error):
                completion(false, error.localizedDescription)
            }
        }
    }
    
    public func saveToken(identifier: String, pushToken: String, completion: @escaping (_ status: Bool, _ error: String?) -> ()) {
        let storedAppId = UserDefaults.standard.string(forKey: Constants.kAppIdKey)
        let storedToken = UserDefaults.standard.string(forKey: Constants.kTokenKey)
        let storedPushToken = UserDefaults.standard.string(forKey: "address")
        var create = true
        if storedPushToken != nil {
            if storedPushToken == pushToken {
                completion(false, "Already saved")
                return
            }
            create = false
        }
        if (storedAppId == nil) {
            completion(false, "No app id registered")
            return
        }
        let request = AF.request(
            Constants.kBaseUrl + "/" + Constants.kApiVersion + "/" + (create ? Constants.kBindingAPI : Constants.kBindingsRefreshAPI),
            method: HTTPMethod.post,
            parameters: create ? [
                "address": pushToken,
                "identifier": identifier,
                "type": "apn"
            ] : [
                "old_address": storedPushToken!,
                "address": pushToken
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
    
    public func markNotification(type: NotificationReadType, userInfo: [String: Any], completion: @escaping (_ status: Bool, _ error: String?) -> ()) {
        let storedAppId = UserDefaults.standard.string(forKey: Constants.kAppIdKey)
        let storedToken = UserDefaults.standard.string(forKey: Constants.kTokenKey)
        guard let messageId = userInfo["uni_message_id"] as? String else {
            completion(false, "Not handled")
            return
        }
        if (storedAppId == nil) {
            completion(false, "No app id registered")
        }
        let request = AF.request(
            Constants.kBaseUrl + "/" + Constants.kApiVersion + "/" + (type == NotificationReadType.read ? Constants.kNotificationsReadAPI : Constants.kNotificationsReceivedAPI ),
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
