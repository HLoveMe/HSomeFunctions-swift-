//
//  ViewController.swift
//  HScrollView
//
//  Created by 朱子豪 on 16/3/8.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let array:[imageAbleConversion] = ["http://e.hiphotos.bdimg.com/imgad/pic/item/500fd9f9d72a6059a1f411202f34349b033bba20.jpg","http://c.hiphotos.bdimg.com/imgad/pic/item/00e93901213fb80ec98291ed31d12f2eb93894bd.jpg","http://f.hiphotos.baidu.com/image/pic/item/e1fe9925bc315c60d916f9d58ab1cb134954770d.jpg"]
        let one = HScrollView.scrollView(CGRectMake(0, 0,view.width,view.height-100), source:array,title:["000000","111111","2222222"])
        one.center = self.view.center
        one.delegate = self
        let center = self.view.center
        let page = HPageControl(frame:CGRectMake(center.x  - 50, center.y * 2 - 40, 100, 20))
        page.currentPageIndicatorTintColor = UIColor.redColor()
        page.pageIndicatorTintColor = UIColor.blackColor()
//        one.replacePageControl(page)
        one.autoScrollTime = 4
        self.view.addSubview(one)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func  touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        UIImageCache.deleteAllCache()
    }

}
extension ViewController:HScrollViewDelegate{
    
    func HScrollViewDidTouchUp(scrollView: HScrollView, indexPath: NSIndexPath) {
        print("\(indexPath)"+"Touch")
    }
    func HScrollViewWillShowCell(scrollView: HScrollView, indexPath: NSIndexPath) {
        print("\(indexPath)"+"Will")
    }
}

