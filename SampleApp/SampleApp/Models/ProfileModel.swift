//
//  ProfileModel.swift
//  SampleApp
//
//  Created by zhouwenshuang on 2019/7/31.
//  Copyright © 2019 LinkedIn. All rights reserved.
//

import UIKit
import RocketData

final class ProfileModel: SampleAppModel, Equatable {
    let id: Int
    let name: String
    let online: Bool
    let age : Int
    
    
    init(id: Int, name: String, online: Bool, age: Int = -100) {
        self.id = id
        self.name = name
        self.online = online
        self.age = age
    }
    
    // MARK: - SampleAppModel
    
    required init?(data: [AnyHashable: Any]) {
        guard let id = data["id"] as? Int,
            let name = data["name"] as? String,
            let online = data["online"] as? Bool,
            let age = data["age"] as? Int else {
                return nil
        }
        self.id = id
        self.name = name
        self.online = online
        self.age = age
    }
    
    func data() -> [AnyHashable: Any] {
        return [
            "id": id,
            "name": name,
            "online": online,
            "age": age
        ]
    }
    
    // MARK: - Rocket Data Model
    
    var modelIdentifier: String? {
        // We prepend UserModel to ensure this is globally unique
        return "UserModel:\(id)"
    }
    
    func map(_ transform: (Model) -> Model?) -> ProfileModel? {
        // No child objects, so we can just return self
        return self
    }
    
    func forEach(_ visit: (Model) -> Void) {
    }
    
    var projectionIdentifier: String? {
        return "ProfileModel:\(id)"
    }
    
    func merge(_ model: Model) -> Model {
        if let model = model as? ProfileModel {
            return model
        } else if let model = model as? UserModel {
            return ProfileModel(id: model.id, name: model.name, online: model.online)
        } else {
            return self
        }
    }
}

func ==(lhs: ProfileModel, rhs: ProfileModel) -> Bool {
    return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.online == rhs.online &&
        lhs.age == rhs.age
}

