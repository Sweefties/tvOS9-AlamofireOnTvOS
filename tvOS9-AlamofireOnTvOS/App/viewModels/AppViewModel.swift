//
//  AppViewModel.swift
//  tvOS9-AlamofireOnTvOS
//
//  Created by Wlad Dicario on 07/10/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//

import UIKit

struct AppViewModel: AppTextCellDataSource {
    var title = "App Index"
}

extension AppViewModel: AppTextCellDelegate {
    
    var textColor: UIColor {
        return .blackColor()
    }
}
