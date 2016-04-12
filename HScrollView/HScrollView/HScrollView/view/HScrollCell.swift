//
//  HScrollCell.swift
//  HScrollView
//
//  Created by 朱子豪 on 16/3/8.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

import UIKit

class HScrollCell: UICollectionViewCell {
    private var imageView:UIImageView = {
        let one =  UIImageView.init()
        one.contentMode = cellImageModel
        return one
    }()
    private var bottomLabel:UILabel = {
        var one:UILabel = UILabel.init()
        let temp:CGFloat = 0.8
        one.backgroundColor = cellBottomLabelColor
        one.enabled = false
        return one
    }()
    private var title:String?
    private var image:imageAbleConversion?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(bottomLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        self.bottomLabel.frame = CGRectMake(0,self.height-cellBottomLabelHeight, self.width, cellBottomLabelHeight)
        let temp = "   " + (self.title ?? "")
        let attText = NSAttributedString.init(string:temp, attributes: cellBottomLabelAttribute)
           self.bottomLabel.attributedText = attText
        if (placeImageName as NSString).length >= 1{
           self.imageView.image =  UIImage(named:placeImageName)
        }
        self.image?.getImage({ (image) -> () in
            guard let _ = image else {return}
            self.imageView.image = image!
        })
    }
    func setImage(image:imageAbleConversion,title:String?){
        self.title = title
        if self.title == nil {
            self.bottomLabel.hidden = true
        }
        self.image = image
        self.setNeedsLayout()
    }
}



