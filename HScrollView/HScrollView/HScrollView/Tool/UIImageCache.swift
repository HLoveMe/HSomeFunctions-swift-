//
//  Cache.swift
//  对网络和本地图片的缓存功能
//
//  Created by 朱子豪 on 16/3/8.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

import UIKit
/**
 *  得到图片协议
 */
public protocol imageAbleConversion{
    func getImage(option:(UIImage?)->());
}
/**
 *  得到图片路径/名字
 */
public protocol StringConversion{
    func getString()->String;
}

extension String:imageAbleConversion,StringConversion{
    public func getString() -> String {
        return self
    }
    public func getImage(option:(UIImage?)->()){
        UIImageCache.getImage(self, option: option)
    }
}

extension UIImage:imageAbleConversion{
    public func getImage(option:(UIImage?)->()){
        return option(self)
    }
}
extension NSURL:imageAbleConversion,StringConversion{
    public func getString() -> String {
        return self.absoluteString
    }
    public func getImage(option:(UIImage?)->()){
        UIImageCache.getImage(self, option: option)
    }
}

class UIImageCache{
    static var outTime = 7 //天
    static var path:String = {
        var document = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true).last!
        document.appendContentsOf("/scroll-image")
        let manager = NSFileManager.defaultManager()
        if(!manager.fileExistsAtPath(document)){
            try? manager.createDirectoryAtPath(document, withIntermediateDirectories: true, attributes: nil)
        }
        return  document
    }()
    static func getImage(imageOption:StringConversion,option:(UIImage?)->()){
        //本地文件
        let image:UIImage? = UIImage.init(named:imageOption.getString())
        if let _ = image{return option(image)}
        //网络已经保存
        var data:NSData?
        var temp = path
        temp.appendContentsOf("//"+(imageOption.getString() as NSString).lastPathComponent)
        data = NSData.init(contentsOfFile:temp)
        if let _ = data { return option(UIImage.init(data: data!))}
        //网络
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let url = NSURL.init(string: imageOption.getString())
            guard let _ = url else {return option(nil)}
            data =  NSData.init(contentsOfURL:url!)
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                guard let _ = data else{return option(nil)}
                option(UIImage.init(data: data!))
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    data?.writeToFile(temp, atomically:true)
                }
                
            })
        }
    }
    /**删除本地加载的图片 lib/cache/scroll-image */
    static func deleteAllCache()->(){
        let manager = NSFileManager.defaultManager()
        let paths:[String]? = try? manager.contentsOfDirectoryAtPath(path)
        guard let _ = paths else{return}
        paths!.map { (one) -> Void in
            try? manager.removeItemAtPath((path as NSString).stringByAppendingPathComponent(one))
        }
    }
    /**删除过期图片 lib/cache/scroll-image */
    static func deleteOutTimeFile()->(){
        let manager = NSFileManager.defaultManager()
        let paths:[String]? = try? manager.contentsOfDirectoryAtPath(path)
        guard let _ = paths else{return}
        let now:Double = NSDate.init().timeIntervalSince1970
        paths!.map { (one) -> Void in
            let dic = try? manager.attributesOfItemAtPath(one)
            let date:NSDate = dic![NSFileCreationDate] as! NSDate
            let old:Double = date.timeIntervalSince1970
            let len = abs(now-old)
            if(Int(len) >= outTime * 24 * 3600){
                try? manager.removeItemAtPath(one)
            }
        }
        
    }
}