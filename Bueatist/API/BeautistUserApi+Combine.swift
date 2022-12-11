//
//  BeautistUserApi+Combine.swift
//  Bueatist
//
//  Created by Hertz on 12/11/22.
//

import Foundation
import Combine
import CombineExt

extension BeautistUserApi {
    
    // ⭐️ 성공
    /// - Parameters:
    ///   - userName: 유저닉네임
    ///   - email: 유저이메일
    ///   - password: 유저패스워드
    // MARK: - 회원가입 Api - "POST"
    static func signupWithPublisher(userName: String, email: String, password: String) -> AnyPublisher<UserResponse, ApiError> {
        
        /// 파람
        let requestParams: [String:Any] = [
            "username":userName,
            "email":email,
            "password":password
        ]
        
        // MARK: - URLRequest를 만든다
        let urlString: String = baseURL + "users"
        
        guard let url: URL = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowUrl).eraseToAnyPublisher()
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue("1", forHTTPHeaderField: "X-Parse-Revocable-Session")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        do {
            // 딕셔너리를 JSONData 로 만들기
            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            // JSON형태로 만든 데이터를 httpBody에 넣기
            urlRequest.httpBody = jsonData
        } catch {
            // JSON serialization failed
            return Fail(error: ApiError.jsonEncodingError).eraseToAnyPublisher()
        }
        
        // MARK: - ⭐️ URLSession.DataTaskPublisher -> AnyPublisher<UserResponse, ApiError> 형태로 변경해서 리턴
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, response: URLResponse) -> Data in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❗️Bad Status Code❗️")
                    throw ApiError.unKnown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    throw ApiError.unAuthorized
                default:
                    print("default: \(httpResponse.statusCode)⭐️")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
                
            })
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .mapError({ dataTaskPublisherErrorType -> ApiError in
                
                if let error = dataTaskPublisherErrorType as? ApiError {
                    return error
                }
                
                if dataTaskPublisherErrorType is DecodingError {
                    return ApiError.decodingError
                }
                
                return ApiError.unKnown(nil)
                
            })
            .eraseToAnyPublisher()
    }
    
    // ⭐️
    /// - Parameters:
    ///   - userName: 유저이름
    ///   - password: 유저패스워드
    // MARK: - 로그인하기 API - "GET"
    static func loginWithPublisher(userName: String, password: String) -> AnyPublisher<UserResponse, ApiError> {
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/login?username=hertz315&password=%40%40Ghdrn315
        var urlComponents = URLComponents(string: baseURL + "login?")!
        urlComponents.queryItems = [
            URLQueryItem(name: "username", value: userName),
            URLQueryItem(name: "password", value: password)
        ]
        
        guard let url = urlComponents.url else {
            // 에러를 보내고 데이터 스트림 끊어 버리기
            return Fail(error: ApiError.notAllowUrl) // ⭐️ Fail 타입 을 AnyPulisher타입으로 변경해줘야 함
                .eraseToAnyPublisher()
        }
        
        
        // URLRequest 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue("1", forHTTPHeaderField: "X-Parse-Revocable-Session")
        
        // MARK: - dataTaskPublisher
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
        // ⭐️ 에러를 던저야 되기 때문에 .map 말고 .tryMap 사용해야 함
            .tryMap({ (data: Data, response: URLResponse) -> Data in
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❗️Bad Status Code❗️")
                    throw ApiError.unKnown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 에러를 던지면 밖으로 나가기 때문에 리턴안해도 됨
                    throw ApiError.unAuthorized
                default:
                    print("default: \(httpResponse.statusCode)⭐️")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
            }) // Data
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .tryMap({ response in
                guard let content = response.objectID, !content.isEmpty else {
                    throw ApiError.userNotCreated
                }
                return response
            })
            .mapError({ error -> ApiError in
                // dataTaskPublisher 형태의 에러를 커스텀 Error 타입으로 변경📌
                if let err = error as? ApiError {
                    return err
                }
                
                // 디코딩할때 발생핤수 있는 에러를 커스텀 Error 타입으로 변경📌
                if error is DecodingError {
                    return ApiError.decodingError
                }
                
                return ApiError.unKnown(nil)
            })
            .eraseToAnyPublisher()
        
    }
    
    
    // ⭐️
    /// - Parameters:
    ///   - objectId: 유저객체ID
    ///   - completion: 응답타입 클로저 터트리기
    // MARK: - 특정 유저 검색하기 API "GET"
    static func userRetrievingWithPublisher(objectId: String) -> AnyPublisher<UserResponse, ApiError> {
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/users/ndDZyHxTVc
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "users/" + objectId
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowUrl).eraseToAnyPublisher()
        }
        
        // URLRequest 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        // MARK: - URLSession으로 API를 호출하기
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap{ (data: Data, response: URLResponse) -> Data in
                
                // 응답값이 HTTPURLResponse 응답값이 없다면 에러던지기
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❗️Bad Status Code❗️")
                    throw ApiError.unKnown(nil)
                }
                
                // httpResponse 상태코드가 401 회원 인증 에러❗️
                switch httpResponse.statusCode {
                case 401:
                    throw ApiError.unAuthorized
                default:
                    print("default: \(httpResponse.statusCode)⭐️")
                }
                
                // 만약 상태 응답값 코드가 200~299 사이가 아니라면 에러던지기❗️
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data // Data
            }
        // Data -> 디코딩
            .decode(type: UserResponse.self, decoder: JSONDecoder())
        // 디코딩 상태보고 파싱한 에러의 상태에 따라 에러처리
        // mapError로 에러 타입을 변경한다 ⭐️any Error -> BeautistUserApi.ApiError⭐️
            .mapError({ error -> ApiError in
                // dataTaskPublisher 형태의 에러를 커스텀 Error 타입으로 변경📌
                if let err = error as? ApiError {
                    return err
                }
                
                // 디코딩할때 발생핤수 있는 에러를 커스텀 Error 타입으로 변경📌
                if error is DecodingError {
                    return ApiError.decodingError
                }
                
                return ApiError.unKnown(nil)
            })
            .eraseToAnyPublisher()
        
    }
    
    // ⭐️
    /// - Parameters:
    ///   - sessionToken: 세션토큰
    ///   - completion: 응답타입 클로저 터트리기
    // MARK: - 현재 사용자 검색하기 Api "GET"
    static func currentUserRetrievingWithPublisher(sessionToken: String) -> AnyPublisher<UserResponse, ApiError> {
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/users/me
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "users/" + "me"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowUrl).eraseToAnyPublisher()
        }
        
        // URLRequest 생성
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue(sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        
        // MARK: - URLSession으로 API를 호출하기
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, response: URLResponse) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❗️Bad Status Code❗️")
                    throw ApiError.unKnown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 에러를 던지면 밖으로 나가기 때문에 리턴안해도 됨
                    throw ApiError.unAuthorized
                default:
                    print("default: \(httpResponse.statusCode)⭐️")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
                
            })
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .mapError { dataTaskErrorType -> ApiError in
                
                if let error = dataTaskErrorType as? ApiError {
                    return error
                }
                
                if dataTaskErrorType is DecodingError {
                    return ApiError.decodingError
                }
                
                return ApiError.unKnown(nil)
            }
            .eraseToAnyPublisher()
        
    }
    
    
    /// - Parameters:
    ///   - sessionToken: 세션토큰
    ///   - userName: 수정할 유저닉네임
    ///   - email: 수정할 이메일
    // MARK: - 유저 정보 수정 Api "PUT
    static func editUserInformationWithPublisher(sessionToken: String, objectId: String, userName: String, email: String) -> AnyPublisher<UserResponse, ApiError> {
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/users/jSSAQpjmWC
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "users/" + objectId
        
        let requestParams: [String:Any] = [
            "username":userName,
            "email":email,
        ]
        
        guard let url: URL = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowUrl).eraseToAnyPublisher()
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue(sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "PUT"
        
        do {
            // 딕셔너리를 JSONData 로 만들기
            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            // JSON형태로 만든 데이터를 httpBody에 넣기
            urlRequest.httpBody = jsonData
        } catch {
            // JSON serialization failed
            return Fail(error: ApiError.jsonEncodingError).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❗️Bad Status Code❗️")
                    throw ApiError.unKnown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 에러를 던지면 밖으로 나가기 때문에 리턴안해도 됨
                    throw ApiError.unAuthorized
                default:
                    print("default: \(httpResponse.statusCode)⭐️")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
                
            }
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .mapError { dataTaskPublisherError -> ApiError in
                
                if let error = dataTaskPublisherError as? ApiError {
                    return error
                }
                
                if dataTaskPublisherError is DecodingError {
                    return ApiError.decodingError
                }
                
                return ApiError.unKnown(nil)
            }
            .eraseToAnyPublisher()
        
    }
    
    // ⭐️
    /// - Parameters:
    ///   - sessionToken: 유저 세션토큰
    ///   - objectId: 유저 아이디
    // MARK: - 유저 삭제하기 Api "DELETE"
    static func deleteUserWithPublisher(sessionToken: String, objectId: String) -> AnyPublisher<UserResponse, ApiError> {
        
        print(#fileID, #function, #line, "deleteUserAPI 호출됨⭐️")
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/users/a9JbehvWhv
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "users/" + objectId
        
        guard let url: URL = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowUrl).eraseToAnyPublisher()
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue(sessionToken, forHTTPHeaderField: "X-Parse-Session-Token")
        urlRequest.httpMethod = "DELETE"
        
        // MARK: - URLSession으로 API를 호출한다 && API호출에 대한 응답을 받는다
        // 만든URLRequest를 가지고 데이터 추출
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap({ (data: Data, response: URLResponse) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❗️Bad Status Code❗️")
                    throw ApiError.unKnown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 에러를 던지면 밖으로 나가기 때문에 리턴안해도 됨
                    throw ApiError.unAuthorized
                default:
                    print("default: \(httpResponse.statusCode)⭐️")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
                
            })
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .mapError { dataTaskPublisherErrorType -> ApiError in
                if let error = dataTaskPublisherErrorType as? ApiError {
                    return error
                }
                
                if dataTaskPublisherErrorType is DecodingError  {
                    return ApiError.decodingError
                }
                
                return ApiError.unKnown(nil)
                
            }
            .eraseToAnyPublisher()
        
    }
    
    /// - Parameters:
    ///   - email: 유저이메일
    // MARK: - 확인이메일요청 Api "POST"
    static func verificationEmailRequestWithPublisher(email: String) -> AnyPublisher<UserResponse, ApiError> {
        
        let requestParams: [String:Any] = [
            "email":email,
        ]
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/verificationEmailRequest
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "verificationEmailRequest/"
        
        guard let url: URL = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowUrl).eraseToAnyPublisher()
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        
        do {
            // 딕셔너리를 JSONData 로 만들기
            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            // JSON형태로 만든 데이터를 httpBody에 넣기
            urlRequest.httpBody = jsonData
        } catch {
            // JSON serialization failed
            return Fail(error: ApiError.jsonEncodingError).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
        // tryMap: 클로저 내부에서 예외가 던져질 수 있는 연산이 있을때 사용
            .tryMap({ (data: Data, response: URLResponse) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❗️Bad Status Code❗️")
                    throw ApiError.unKnown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 에러를 던지면 밖으로 나가기 때문에 리턴안해도 됨
                    throw ApiError.unAuthorized
                default:
                    print("default: \(httpResponse.statusCode)⭐️")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
            })
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .mapError { dataTaskPublisherErrorType -> ApiError in
                
                if let error = dataTaskPublisherErrorType as? ApiError {
                    return error
                }
                
                if dataTaskPublisherErrorType is DecodingError {
                    return ApiError.decodingError
                }
                
                return ApiError.unKnown(nil)
                
            }
            .eraseToAnyPublisher()
        
    }
    
    /// - Parameters:
    ///   - email: 유저이메일
    // MARK: - 확인이메일요청 Api "POST"
    static func requestPasswordResetWithPublisher(email: String) -> AnyPublisher<UserResponse, ApiError> {
        
        let requestParams: [String:Any] = [
            "email":email,
        ]
        
        // MARK: - URLRequest를 만든다
        // https://parseapi.back4app.com/requestPasswordReset
        // baseURL = https://parseapi.back4app.com/
        let urlString = baseURL + "requestPasswordReset"
        
        guard let url: URL = URL(string: urlString) else {
            return Fail(error: ApiError.notAllowUrl).eraseToAnyPublisher()
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "accept")
        urlRequest.addValue("WCONfRfv8aio2yPtqOYWcWZKMltIj9IkkkCkFeyl", forHTTPHeaderField: "X-Parse-Application-Id")
        urlRequest.addValue("9EjhBUWG4G9aql4Q2GlTr9NqriQxbpaR2XCYQTSg", forHTTPHeaderField: "X-Parse-REST-API-Key")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        
        
        do {
            // 딕셔너리를 JSONData 로 만들기
            let jsonData: Data = try JSONSerialization.data(withJSONObject: requestParams, options: [.prettyPrinted])
            // JSON형태로 만든 데이터를 httpBody에 넣기
            urlRequest.httpBody = jsonData
        } catch {
            // JSON serialization failed
            return Fail(error: ApiError.jsonEncodingError).eraseToAnyPublisher()
        }
        
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❗️Bad Status Code❗️")
                    throw ApiError.unKnown(nil)
                }
                
                switch httpResponse.statusCode {
                case 401:
                    // 에러를 던지면 밖으로 나가기 때문에 리턴안해도 됨
                    throw ApiError.unAuthorized
                default:
                    print("default: \(httpResponse.statusCode)⭐️")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw ApiError.badStatus(code: httpResponse.statusCode)
                }
                
                return data
                
            }
            .decode(type: UserResponse.self, decoder: JSONDecoder())
            .mapError { dataTaskPublisherErrorType -> ApiError in
                
                if let error = dataTaskPublisherErrorType as? ApiError {
                    return error
                }
                
                if dataTaskPublisherErrorType is DecodingError {
                    return ApiError.decodingError
                }
                
                return ApiError.unKnown(nil)
                
            }
            .eraseToAnyPublisher()
    }
    
    // ⭐️
    /// - Parameters:
    ///   - userName: 유저닉네임
    ///   - email: 유저이메일
    ///   - password: 유저페스워드
    // MARK: - 회원가입하고 로그인하기 / 연쇄 API 호출⭐️
    static func signupUserAndLoginUserWithPublisher(userName: String, email: String, password: String) -> AnyPublisher<UserResponse, ApiError> {
        // 회원가입이 성공하면 리턴 그후 FlatMap오퍼레이터 사용하여 로그인 API 호출
        return self.signupWithPublisher(userName: userName, email: email, password: password)
            .map { _ in
                self.loginWithPublisher(userName: userName, password: password)
            }
            .switchToLatest()
            .eraseToAnyPublisher()

    }
    
    // ⭐️
    //sessionToken: String, objectId: String
    /// - Parameters:
    ///   - sessionTokens: 삭제할 유저 토큰 배열
    ///   - ObjectIds: 삭제할 유저 Id 배열
    // MARK: - 동시 유저 삭제 / 동시 API 호출⭐️
    static func deleteSelectedUsersWithPublisher(deleteUserTokenAndIdDictionary: [String:String]) -> AnyPublisher<[String:String], ApiError> {
        
        let apiCallPublishers: [AnyPublisher<[String : String], BeautistUserApi.ApiError>] =
        
            deleteUserTokenAndIdDictionary.map { id -> AnyPublisher<[String:String], ApiError> in
            
            return self.deleteUserWithPublisher(sessionToken: id.key, objectId: id.value)
                .map { [$0.sessionToken ?? "" : $0.objectID ?? ""] }
                .eraseToAnyPublisher()
        }
        
        return Publishers.MergeMany(apiCallPublishers).eraseToAnyPublisher()
        
    }
    
    
}
