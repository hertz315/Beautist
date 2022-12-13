//
//  UserLoginResponse.swift
//  Bueatist
//
//  Created by Hertz on 12/9/22.
//

import Foundation

// Json -> Struct, Class == Decoding 한다
// Strcut, Class -> Json == Encoding 한다
// Codable 프로토콜 == Decodable & Encodable

// MARK: - 유저
struct UserResponse: Codable {
    let objectID, username, email, createdAt, password: String?
    let updatedAt: String?
    let acl: ACL?
    let profilePhoto: Photo?
    let type, className, sessionToken: String?

    enum CodingKeys: String, CodingKey {
        case objectID = "objectId"
        case username, email, createdAt, updatedAt
        case acl = "ACL"
        case type = "__type"
        case className, sessionToken
        case password
        case profilePhoto
    }
}

// MARK: - 유저 정보수정
struct EditUser: Codable {
    let updatedAt: String?
}

// MARK: - ACL
struct ACL: Codable {
    let empty: Empty?
    let ndDZyHxTVc: NdDZyHxTVc?

    enum CodingKeys: String, CodingKey {
        case empty = "*"
        case ndDZyHxTVc
    }
}

// MARK: - Photo
struct Photo: Codable {
    let type, name: String?

    enum CodingKeys: String, CodingKey {
        case type = "__type"
        case name
    }
}

// MARK: - Empty
struct Empty: Codable {
    let read: Bool?
}

// MARK: - NdDZyHxTVc
struct NdDZyHxTVc: Codable {
    let read, write: Bool?
}

