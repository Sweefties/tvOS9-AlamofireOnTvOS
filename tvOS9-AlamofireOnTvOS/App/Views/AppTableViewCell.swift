//
//  AppTableViewCell.swift
//  tvOS9-AlamofireOnTvOS
//
//  Created by Wlad Dicario on 07/10/2015.
//  Copyright © 2015 Sweefties. All rights reserved.
//

import UIKit

protocol AppTextCellDataSource {
    var title: String { get }
}

protocol AppTextCellDelegate {
    var textColor: UIColor { get }
    var font: UIFont { get }
}

extension AppTextCellDelegate {
        
    var textColor: UIColor {
        return .blackColor()
    }
    
    var font: UIFont {
        return .systemFontOfSize(38)
    }
}


class AppTableViewCell: UITableViewCell {
    
    private var delegate: AppTextCellDelegate?
    private var dataObject: AppModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.detailTextLabel?.textColor = .lightGrayColor()
        self.imageView?.image = UIImage(named: "Placeholder")
    }
    /**
     Configure the current Cell with data Object Model and delegate protocol.
     - parameter dataObject:     The App Model object to layout.
     - parameter delegate:       The AppTextCellDelegate optionnal protocol.
     - returns: The current Cell setted a new object model with `dataObject` from dataObject.
     */
    func configure(withDataSource dataObject: AppModel, delegate: AppTextCellDelegate?) {
        self.dataObject = dataObject
        self.delegate = delegate
        
        let appTitle = dataObject.trackName
        let appAuthor = dataObject.sellerName
        let appArtworkUrl = dataObject.thumbnailUrl
        
        self.textLabel?.text = "\(appTitle)"
        self.detailTextLabel?.text = "\(appAuthor)"
        
        self.textLabel?.font = delegate?.font
        self.textLabel?.textColor = delegate?.textColor
        
        // set placeholder image first.
        self.imageView?.image = UIImage(named: "Placeholder")
        self.imageView?.downloadImageFrom(url: appArtworkUrl, contentMode: UIViewContentMode.ScaleAspectFit)
    }
}
