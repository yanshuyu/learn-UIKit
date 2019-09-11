//
//  PhotoRecord.swift
//  10_OperationQueue
//
//  Created by sy on 2019/9/11.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit

enum PhotoRecordStatus {
    case Initiated
    case Downloaded
    case Filtered
    case Failed
}

class PhotoRecord: NSObject {
    var name: String
    var url: URL
    lazy var image: UIImage? = {
        return UIImage(named: "Placeholder")
    }()
    var status: PhotoRecordStatus = .Initiated

    init(url:URL, name: String) {
        self.url = url
        self.name = name
        super.init()
    }
}
