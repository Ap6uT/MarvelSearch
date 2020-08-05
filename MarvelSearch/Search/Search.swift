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

enum ApiResult<Value, Error> {
    case success(Value)
    case failure(Error)
    
    init(value: Value){
        self = .success(value)
    }
    
    init(error: Error){
        self = .failure(error)
    }
}

enum RequestType {
    case id(Int)
    case name(String)
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
    let thumbnail: Thumbnail
}

struct Thumbnail: Codable{
    let path: String
    let fileExtension: String
    
    enum CodingKeys: String, CodingKey {
        case fileExtension = "extension"
        case path
    }
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
    
    let API = "https://gateway.marvel.com/v1/public/characters"
    //let charactersSearchEndpoint = ""

    
    let characters = BehaviorRelay<[ResponseResult]>(value: [])
    
    private init() {
    }
    
    
    func searchCharacterByName(_ character: String) {
        searchCharacter(.name(character))
    }
    
    func searchCharacterById(_ id: Int) {
        searchCharacter(.id(id))
    }
    
    func searchCharacter(_ requestType: RequestType) {
        let timeStamp = ts
        let hash = (timeStamp + privateKey + publicKey).md5()
        var parameters = ["ts": timeStamp, "apikey": publicKey, "hash": hash]
        var APIrequest = API
        switch requestType {
        case .id(let characterId):
            APIrequest += "/\(characterId)"
        case .name(let characterName):
            parameters["nameStartsWith"] = characterName
        }
        let _ = manager.rx
            .request(.get, APIrequest, parameters: parameters)
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
