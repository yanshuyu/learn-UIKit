//
//  DetailMenuItem.swift
//  07_IOSDrawing
//
//  Created by sy on 2019/9/21.
//  Copyright © 2019 sy. All rights reserved.
//

enum DetailType {
    case fetchThumbnail
    case fetchSubImage
    case fetchGrayScale
    case waterMark
}

class DetailMenuItem {
    var menuLable: String
    var detailTitle: String
    var detailType: DetailType
    
    init(menuLable: String, detailTitle: String, detailType: DetailType) {
        self.menuLable = menuLable
        self.detailTitle = detailTitle
        self.detailType = detailType
    }
    
    class func allDetailMenuItems() -> [DetailMenuItem] {
        return [
            DetailMenuItem(menuLable: "01-fetch thumbnail image", detailTitle: "ThumbnailImageDemo", detailType: .fetchThumbnail),
            DetailMenuItem(menuLable: "02-fetch subImage", detailTitle: "SubImageDemo", detailType: .fetchSubImage),
        ]
    }
    
}
