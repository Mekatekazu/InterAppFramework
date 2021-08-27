//
//  InputCommand.swift
//  InterAppFramework
//
//  Created by Александр Соломатов on 18/10/2018.
//  Copyright © 2018 Александр Соломатов. All rights reserved.
//

import Foundation

//swiftlint:disable identifier_name

/// Input Commands
///
/// - CheckService: Check if device service is started
/// - StartService: Start device service
/// - Scan: Start/Stop scan command 
public enum InputCommand: String, Codable {
    /// Check if service is already started
    /*case CheckService
    
    /// Start DeviceService
    case StartService
    
    /// Scan command
    case Scan(start: Bool)*/
    
    case CheckSubscription
}

/*extension InputCommand: Codable, Equatable {
    private enum CodingKeys: String, CodingKey {
        case base, scan
    }
    
    private enum Base: String, Codable {
        case checkService, startService, scanCommand, checkSubscription
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let base = try container.decode(Base.self, forKey: .base)
        
        switch base {
        case .checkService:
            self = .CheckService
        case .startService:
            self = .StartService
        case .scanCommand:
            let scanState = try container.decode(Bool.self, forKey: .scan)
            self = .Scan(start: scanState)
        case .checkSubscription:
            self = .CheckSubscription
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case .CheckService:
            try container.encode(Base.checkService, forKey: .base)
        case .StartService:
            try container.encode(Base.startService, forKey: .base)
        case .Scan(let boolValue):
            try container.encode(Base.scanCommand, forKey: .base)
            try container.encode(boolValue, forKey: .scan)
        case .CheckSubscription:
            try container.encode(Base.checkSubscription, forKey: .base)
        }
    }
}*/
