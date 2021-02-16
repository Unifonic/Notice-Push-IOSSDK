import Alamofire

public struct UnfionicAuthenticateSDK {
    //Hello World!
    public init() {
        
    }
    public func initialize() {
        let request = AF.request("https://swapi.dev/api/films")
        request.responseJSON { (data) in
            print(data)
            print(data)
        }
    }
}
