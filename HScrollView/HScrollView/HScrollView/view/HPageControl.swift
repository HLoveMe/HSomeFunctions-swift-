//
//  HPageControl.swift
//  HScrollView
//
//  Created by 朱子豪 on 16/3/9.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

import UIKit

class HPageControl: UIPageControl {
    var currentImage:imageAbleConversion?{
        didSet{
            currentImage?.getImage({ (image) in
                guard let _ = image else {return}
                let color = UIColor.init(patternImage:image!)
                self.currentPageIndicatorTintColor =  color
            })
        }
    }
    
    var normalImage:imageAbleConversion?{
        didSet{
            normalImage?.getImage({ (image) in
                guard let _ = image else {return}
                let color = UIColor.init(patternImage:image!)
                self.pageIndicatorTintColor =  color
            })
        }
    }
}
