//
//  d.swift
//  MoneySaver
//
//  Created by ThuyPH on 12/20/16.
//  Copyright © 2016 McLab. All rights reserved.
//

import Foundation
import UIKit

let COMMON_COLOR = UIColor.init(colorLiteralRed: 25/255.0, green: 121/255.0, blue: 108/255.0, alpha: 1)
let background_color = UIColor.init(colorLiteralRed: 55/255.0, green: 140/255.0, blue: 128/255.0, alpha: 1)

enum DisplayExchangeType: Int {
    case date
    case week
    case month
    case quarter
    case year
    case current
    case back
}

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
}

enum MyStoreType:Int {
    case flash_card = 0
    case word = 1
}

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let THEME_COLOR_MAIN = [0x2ecc71,0xf1c40f,0x1abc9c,0xe67e22,0x3498db,0x9b59b6]
let THEME_COLOR_SECONDARY = [0x27ae60,0xf39c12,0x16a085,0xd35400,0x2980b9,0x9b59b6]
let API_KEY_TRANSLATE_GOOGLE = "AIzaSyAWMT0WwhDsoxFX37p9SXwUstslgnS_FVY"
let BING_CLIENT_ID = "fgtranslator-demo"
let BING_CLIENT_SECRET = "GrsgBiUCKACMB+j2TVOJtRboyRT8Q9WQHBKJuMKIxsU="



