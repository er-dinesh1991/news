//
//  ApiManager.swift
//  News
//
//  Created by Dinesh Kumar on 20/12/22.
//

import Foundation
import Alamofire


class ApiManager : NSObject{
    
    static let kBaseURL = "https://newsapi.org/v2/"
    
    enum services :String{
        case newslist = "everything"
    }
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var url :String! = kBaseURL//"https://jsonplaceholder.typicode.com/"
    var encoding: ParameterEncoding! = JSONEncoding.default
    
    init(requestData: [String:Any],headers: [String:String] = [:],url :String?,service :services? = nil, method: HTTPMethod = .post, isJSONRequest: Bool = true){
        super.init()
        parameters.updateValue(Constant.kApiKey, forKey: "apiKey")
        requestData.forEach{parameters.updateValue($0.value, forKey: $0.key)}
        
        headers.forEach({self.headers.add(name: $0.key, value: $0.value)})
        
        if url == nil, service != nil{
            self.url += service!.rawValue
        }else{
            self.url = url
        }
        if !isJSONRequest{
            encoding = URLEncoding.default
        }
        
        self.method = method
        print("Api Url :- \(self.url ?? "") \nRequest Data: \(parameters)")
        
        print("Request Header :- \(self.headers.dictionary)")
    }
    
    func executeQuery<T>(completion: @escaping(_ result : Result<T, Error>) -> Void) where T: Codable {
        let noInternetError = NSError(domain: "NO_INTERNET", code: 000, userInfo: [NSLocalizedDescriptionKey : "No Internet available"])
        let networkStatus = NetworkReachabilityManager.default?.status
        switch networkStatus {
        case .notReachable:
            if let vc = UIApplication.topViewController(){
                vc.alert(alertTitle: "No Internet", alertMessage: "Please check internet connection")
            }
            completion(.failure(noInternetError))
            break
        case .reachable(let connectionType):
            print("Internet is available via \(connectionType)")
            AF.request(self.url,method: self.method,parameters: self.parameters,encoding: self.encoding, headers: self.headers).responseData(completionHandler: {response in
                do {
                    switch response.result{
                    case .success(let data):
                        completion(.success(try JSONDecoder().decode(T.self, from: data)))
                        break
                    case .failure(let afError):
                        completion(.failure(afError))
                        break
                    }
                } catch (let error) {
                    completion(.failure(error))
                }
            })
            
            break
        case .unknown:
            completion(.failure(noInternetError))
            break
        default:
            completion(.failure(noInternetError))
            break
        }
    }
}
