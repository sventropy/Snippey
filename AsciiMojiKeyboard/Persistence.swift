//
//  Persistence.swift
//  AsciiMojiKeyboard
//
//  Created by Hennessen, Sven on 29.10.17.
//  Copyright © 2017 Hennessen, Sven. All rights reserved.
//

import Foundation

class Persistence {
    
    // Singleton
    static let sharedInstance = Persistence()
    
    func getDecoder() -> JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }
    
    func loadJsonFile(fileName:String) -> Data {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        return jsonData
    }
    
    func getEmoticons() -> [Emoticon] {
        let emoticonsData = self.loadJsonFile(fileName:"text_emoji")
        return try! self.getDecoder().decode(Array<Emoticon>.self, from: emoticonsData as Data)
    }
}
