import Alamofire

struct UnfionicAuthenticateSDK {
    public func initialize() {
        let request = AF.request("https://swapi.dev/api/films")
        request.responseJSON { (data) in
            print(data)
        }
    }
}
