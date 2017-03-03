//
//  JSONSupport.swift
//  TestEureka
//
//  Created by Thành Lã on 1/14/17.
//  Copyright © 2017 Thành Lã. All rights reserved.
//

import UIKit
import ObjectMapper // -> https://github.com/Hearst-DD/ObjectMapper

struct Meaning {
    let meaningId: Int
    let meaning: String
    let type: Int
}

struct Example {
    let exampleId: Int
    let example: String
    let meaning: String
    let romaji: String
    let kana: String
    let soundUrl: String
    let meaningId: Int
}

struct Trans {
    let id: Int
    let word: String
    let avatar: String
    let romaji: String
    let kana: String
    let soundUrl: String
    let meaning: [Meaning]
    let example: [Example]
    let lastmodifiedDate: String
    let modified: String
}


class DataJSON: ImmutableMappable {
    
    let success: Bool
    let dataJSON: [TranslateJSON]
    let version: String
    let message: String?
    
    var words: [Trans] {
        return dataJSON.map { Trans(id: $0.id,
                                        word: $0.word,
                                        avatar: $0.avatar,
                                        romaji: $0.romaji,
                                        kana: $0.kana,
                                        soundUrl: $0.soundUrl,
                                        meaning: $0.meanings,
                                        example: $0.examples,
                                        lastmodifiedDate: $0.lastmodifiedDate,
                                        modified: $0.modified) }
    }

    
    required public init(map: Map) throws {
        success = try map.value("Success")
        dataJSON = try map.value("Data")
        version = try map.value("Version")
        message = try? map.value("Message")
    }
    
    // Mappable
    func mapping(map: Map) {
        
    }
    
    
    ///
    struct TranslateJSON: ImmutableMappable {
        let id: Int
        let word: String
        let avatar: String
        let romaji: String
        let kana: String
        let soundUrl: String
        let meaning: [MeaningJSON]
        let example: [ExampleJSON]
        let lastmodifiedDate: String
        let modified: String
        
        
        var meanings: [Meaning] {
            return meaning.map { Meaning(meaningId: $0.meaningId, meaning: $0.meaning, type: $0.type) }
        }
        
        
        var examples: [Example] {
            return example.map { Example(exampleId: $0.exampleId,
                                         example: $0.example,
                                         meaning: $0.meaning,
                                         romaji: $0.romaji,
                                         kana: $0.kana,
                                         soundUrl: $0.soundUrl,
                                         meaningId: $0.meaningId) }
        }
        
        
        struct MeaningJSON: ImmutableMappable {
            let meaningId: Int
            let meaning: String
            let type: Int
            
            init(map: Map) throws {
                meaningId = try map.value("MeaningId")
                meaning = try map.value("Meaning")
                type = try map.value("Type")
            }
            
            public func mapping(map: Map) {
                
            }
            
        }
        
        
        
        ///
        struct ExampleJSON: ImmutableMappable {
            let exampleId: Int
            let example: String
            let meaning: String
            let romaji: String
            let kana: String
            let soundUrl: String
            let meaningId: Int
            
            init(map: Map) throws {
                exampleId = try map.value("ExampleId")
                example = try map.value("Example")
                meaning = try map.value("Meaning")
                romaji = try map.value("Romaji")
                kana = try map.value("Kana")
                soundUrl = try map.value("SoundUrl")
                meaningId = try map.value("MeaningId")
            }
            
            public func mapping(map: Map) {
                
            }
            
        }
        
        
        
        init(map: Map) throws {
            
            id = try map.value("Id")
            word = try map.value("Word")
            avatar = try map.value("Avatar")
            romaji = try map.value("Romaji")
            kana = try map.value("Kana")
            soundUrl = try map.value("SoundUrl")
            meaning = try map.value("Meaning")
            example = try map.value("Example")
            lastmodifiedDate = try map.value("LastmodifiedDate")
            modified = try map.value("Modified")
            
        }
        
        public func mapping(map: Map) {
            
        }
        
        
        
    }
    
    
    ///
    
    
    
}

func testConvertJSON() {
    if let filepath = Bundle.main.path(forResource: "data", ofType: "json") {
        
        do {
            let JSONString = try String(contentsOfFile: filepath)
            //                print("JSONString: \(JSONString)")
            let translates = try DataJSON(JSONString: JSONString)
            print("word: \(translates.words.count)")
            
        } catch {
            print(error)
        }
    }
}

struct SoundJSON: ImmutableMappable {
    
    let flashCardID: Int
    let id: Int
    let soundUrl: String
    
    init(map: Map) throws {
        flashCardID = try map.value("FlashCardId")
        id = try map.value("Id")
        soundUrl = try map.value("SoundUrl")
    }
    
    public func mapping(map: Map) {
        
    }
    
}

struct DataSoundJSON: ImmutableMappable {
    let sound: [SoundJSON]
    
    init(map: Map) throws {
        sound = try map.value("Data")
    }
    
    public func mapping(map: Map) {
        
    }
}

public func delay(_ delay: Double, closure:@escaping () -> () ) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}

extension Double {
    public var second:  TimeInterval { return self }
    public var seconds: TimeInterval { return self }
    public var minute:  TimeInterval { return self * 60 }
    public var minutes: TimeInterval { return self * 60 }
    public var hour:    TimeInterval { return self * 3600 }
    public var hours:   TimeInterval { return self * 3600 }
}

//==========================
/*
Data =     (
    {
        Avatar = "http://storage.dekiru.vn/Data/2016/12/03/chaobuoisang-636163694769318529.jpg";
        FlashCardId = 1072;
        Id = 2333;
        Kana = "\U304a\U306f\U3088\U3046";
        Romaji = ohayou;
        SoundUrl = "http://storage.dekiru.vn/Data/2016/11/15/ohayo-636148228403231171.mp3";
        Word = "\U304a\U306f\U3088\U3046";
        WordMeaning = "Ch\U00e0o bu\U1ed5i s\U00e1ng";
},
    {
        Avatar = "http://storage.dekiru.vn/Data/2016/12/03/chaobuoitoi-636163696713162759.jpg";
        FlashCardId = 1072;
        Id = 2334;
        Kana = "\U3053\U3093\U3070\U3093\U306f";
        Romaji = konbanwa;
        SoundUrl = "http://storage.dekiru.vn/Data/2016/11/15/konbanwa-636148228808197709.mp3";
        Word = "\U3053\U3093\U3070\U3093\U306f";
        WordMeaning = "Ch\U00e0o bu\U1ed5i t\U1ed1i";
}
);
ErrorCode = 0;
Message = "";
Success = 1;
TotalRow = 10;
*/
/*
{
    "Id": 8,
    "Word": "バナナ",
    "Avatar": "http://storage.dekiru.vn/Data/2016/12/29/quachuoi-636186263867656599.jpg",
    "Romaji": "banana",
    "Kana": "バナナ",
    "SoundUrl": "http://storage.dekiru.vn/Data/2016/12/29/banana-636186249706055500.mp3",
    "Meaning": [
        {
            "MeaningId": 30102,
            "Meaning": "Chuối, quả chuối",
            "Type": 1
        }
    ],
    "Example": [
        {
            "ExampleId": 7004,
            "Example": "バナナの皮をむく",
            "Meaning": "Bóc vỏ chuối",
            "Romaji": "",
            "Kana": "",
            "SoundUrl": "",
            "MeaningId": 30102
        }
    ],
    "LastmodifiedDate": "/Date(1483004395150+0700)/",
    "Modified": "add"
}
*/
