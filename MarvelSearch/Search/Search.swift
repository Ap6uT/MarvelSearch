//
//  Search.swift
//  MarvelSearch
//
//  Created by Alexander Grishin on 10.07.2020.
//  Copyright © 2020 Alexander Grishin. All rights reserved.
//

import Foundation

import Alamofire
import RxAlamofire

import RxSwift
import RxCocoa

enum ApiResult<Value, Error>{
    case success(Value)
    case failure(Error)
    
    init(value: Value){
        self = .success(value)
    }
    
    init(error: Error){
        self = .failure(error)
    }
}

struct Response: Codable{
    let status: String
    let data: ResponseData
}

struct ResponseData: Codable {
    //let offset: Int
    let results: [ResponseResult]
}

struct ResponseResult: Codable {
    let id: Int
    let name: String
    let description: String
}

struct ApiErrorMessage: Codable{
    let error_message: String
}

class Search {
    var ts: String = {
        return "5"
    }()
    
    public static let shared = Search()

    let session = URLSession.shared
    let manager = Session.default
    
    let publicKey = "06d867e2f65467836f8bdaae97a512ad"
    let privateKey = "fff550e715e67f65dc275c81b5bece1cc278608f"
    
    let API = "https://gateway.marvel.com/v1/public/"
    let charactersSearchEndpoint = "characters"
    let characterEndpoint = "events"
    
    let characters = BehaviorRelay<[ResponseResult]>(value: [])
    
    private init() {
    }
    
    
    func searchCharacter(_ character: String) {
        let timeStamp = ts
        let hash = (timeStamp + privateKey + publicKey).md5()
        let _ = manager.rx
            .request(.get, API + charactersSearchEndpoint, parameters: ["nameStartsWith": character, "ts": timeStamp, "apikey": publicKey, "hash": hash])
            .responseData()
            .expectingObject(ofType: Response.self)
            .subscribe(onNext: { [weak self] apiResult in
                switch apiResult {
                case let .success(response):
                    self?.characters.accept(response.data.results)
                case let .failure(apiErrorMessage):
                    print(apiErrorMessage.error_message)
                }
            },onError:{ err in
                
            })
    }
}



extension Observable where Element == (HTTPURLResponse, Data){
    fileprivate func expectingObject<T : Codable>(ofType type: T.Type) -> Observable<ApiResult<T, ApiErrorMessage>>{
        return self.map{ (httpURLResponse, data) -> ApiResult<T, ApiErrorMessage> in
            switch httpURLResponse.statusCode{
            case 200 ... 299:
                // is status code is successful we can safely decode to our expected type T
                let object = try JSONDecoder().decode(type, from: data)
                return .success(object)
            default:
                // otherwise try
                let apiErrorMessage: ApiErrorMessage
                do{
                    // to decode an expected error
                    apiErrorMessage = try JSONDecoder().decode(ApiErrorMessage.self, from: data)
                } catch _ {
                    // or not. (this occurs if the API failed or doesn't return a handled exception)
                    apiErrorMessage = ApiErrorMessage(error_message: "Server Error.")
                }
                return .failure(apiErrorMessage)
            }
        }
    }
}
