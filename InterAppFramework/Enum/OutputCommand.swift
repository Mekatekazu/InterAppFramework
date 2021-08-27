//
//  OutputCommand.swift
//  InterAppFramework
//
//  Created by Александр Соломатов on 18/10/2018.
//  Copyright © 2018 Александр Соломатов. All rights reserved.
//

import UIKit

public enum OutputCommand {
//    case serviceIsStarted(Bool)
//    case serviceHasData(Data?)
    case serviceHasSubscription(Bool)
}

extension OutputCommand: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case base, /*serviceStatus, serviceData,*/ serviceSubscription
    }
    
    private enum Base: String, Codable {
        case /*serviceStatus, serviceData,*/ serviceSubscription
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        
        switch base {
//        case .serviceStatus:
//            let startState = try container.decode(Bool.self, forKey: .serviceStatus)
//            self = .serviceIsStarted(startState)
//        case .serviceData:
//            let startData = try container.decode(Data.self, forKey: .serviceData)
//            self = .serviceHasData(startData)
        case .serviceSubscription:
            let subscriptionState = try container.decode(Bool.self, forKey: .serviceSubscription)
            self = .serviceHasSubscription(subscriptionState)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        /*case .serviceIsStarted(let boolValue):
            try container.encode(Base.serviceStatus, forKey: .base)
            try container.encode(boolValue, forKey: .serviceStatus)
        case .serviceHasData(let dataValue):
            try container.encode(Base.serviceData, forKey: .base)
            try container.encode(dataValue, forKey: .serviceData)*/
        case .serviceHasSubscription(let boolValue):
            try container.encode(Base.serviceSubscription, forKey: .base)
            try container.encode(boolValue, forKey: .serviceSubscription)
        }
    }
}
