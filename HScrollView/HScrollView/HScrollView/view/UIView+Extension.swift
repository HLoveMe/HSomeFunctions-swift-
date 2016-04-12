//
//  UIView+Extension.swift
//  HScrollView
//
//  Created by 朱子豪 on 16/3/8.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

import UIKit
extension UIView{
    /**size*/
    var size:CGSize {
        get{
            return self.frame.size
        }
        set{
            var rect:CGRect = self.frame
            rect.size = newValue
            self.frame = rect
        }
        
    }
    /**width*/
    var width:CGFloat {
        get{
            return  self.bounds.size.width
        }
        set{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newValue, self.frame.size.height)
        }
    }
    /**height*/
    var height:CGFloat {
        get{
            return  self.bounds.size.height
        }
        set{
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width,newValue)
        }
    }
    /**center*/
    var centerH:CGPoint{
        get{
            return self.center
        }
        set{
            self.frame = CGRectMake(newValue.x - self.width * 0.5, newValue.y - self.height * 0.5 ,self.width,self.height)
        }
    }
    /**origin*/
    var origin:CGPoint{
        get{
            return self.frame.origin
        }
        set{
            var rect:CGRect = self.frame
            rect.origin = newValue
            self.frame = rect
        }
        
    }
    /** x */
    var x:CGFloat{
        get{
            return self.origin.x
        }
        set{
            var rect:CGRect = self.frame
            rect.origin = CGPointMake(newValue, rect.origin.y)
            self.frame = rect
        }
    }
    /** y */
    var y:CGFloat{
        get{
            return self.origin.y
        }
        set{
            var rect:CGRect = self.frame
            rect.origin = CGPointMake(rect.origin.x,newValue)
            self.frame = rect
        }
    }
    
    /**MaxX*/
    var MaxX:CGFloat {
        get{
            return CGRectGetMaxX(self.frame)
        }
        set{
            var rect:CGRect = self.frame
            rect.origin = CGPointMake(newValue - self.width, rect.origin.y)
            self.frame = rect
        }
    }
    /**MaxY*/
    var MaxY:CGFloat{
        get{
            return CGRectGetMaxY(self.frame)
        }
        set{
            var rect:CGRect = self.frame
            rect.origin = CGPointMake(rect.origin.x,newValue - self.height)
            self.frame = rect
        }
    }
    /**下标*/
    subscript(des:String) ->CGFloat{
        get{
            let str = des.lowercaseString
            switch str{
            case "x":
                return self.x
            case "y":
                return self.y
            case "w","wid","width","宽":
                return self.width
            case "h","hei","height","高":
                return self.height
            default:
                return 0
            }
        }
        set{
            let str = des.lowercaseString
            switch str{
            case "x":
                self.x =  newValue
            case "y":
                self.y = newValue
            case "w","wid","width","宽":
                self.width = newValue
            case "h","hei","height","高":
                self.height = newValue
            default:
                break
            }
        }
    }
}


