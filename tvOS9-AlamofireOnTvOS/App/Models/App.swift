//
//  App.swift
//  tvOS9-AlamofireOnTvOS
//
//  Created by Wlad Dicario on 07/10/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//

import Foundation

class AppModel: NSObject {
    
    var trackName:String
    var descriptionText:String
    var thumbnailUrl: String
    var Url: String
    var sellerName: String
    
    override init() {
        trackName = "unknown"
        descriptionText = "unknown"
        thumbnailUrl = ""
        Url = ""
        sellerName = "unknown"
        super.init()
    }
    
    init(trackName:String, descriptionText:String, thumbnailUrl:String, Url:String, sellerName:String) {
        self.trackName = trackName
        self.descriptionText = descriptionText
        self.thumbnailUrl = thumbnailUrl
        self.Url = Url
        self.sellerName = sellerName
        super.init()
    }
    
}