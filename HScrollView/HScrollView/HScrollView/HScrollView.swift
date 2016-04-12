//
//  HScrollView.swift
//  HScrollView
//
//  Created by 朱子豪 on 16/3/8.
//  Copyright © 2016年 朱子豪. All rights reserved.
//

import UIKit
@objc protocol HScrollViewDelegate:NSObjectProtocol{
//  touch Cell
    optional func HScrollViewDidTouchUp(scrollView:HScrollView,indexPath:NSIndexPath);
// 将要显示一个cell Dragging
    optional func HScrollViewWillShowCell(scrollView:HScrollView,indexPath:NSIndexPath);
}
class HScrollView: UIView {
    var delegate:HScrollViewDelegate?
    var autoScroll:Bool = true{
        didSet{
            self.setTimer()
        }
    }
    var autoScrollTime:NSTimeInterval = 2{ //秒
        didSet{
            self.setTimer()
        }
    }
    private var timer:NSTimer?
    private var title:[String]?
    private var dataArray:[imageAbleConversion]!
    private var follow:UICollectionViewFlowLayout!
    private var totalNum:Int = 0
    private var currentIndex:Int = 0
    private lazy var mainView:UICollectionView = {
        let follow:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        self.follow = follow
        follow.itemSize = CGSizeMake(0,0)
        follow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        follow.minimumInteritemSpacing = 0
        follow.minimumLineSpacing = 0
        follow.scrollDirection = .Horizontal
        var collView:UICollectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: self.follow)
        collView.registerClass(HScrollCell.self, forCellWithReuseIdentifier: "HScrollCell")
        collView.delegate = self
        collView.dataSource = self
        collView.pagingEnabled = true
        collView.showsHorizontalScrollIndicator = false
        collView.showsVerticalScrollIndicator = false
        collView.bounces = false
        return collView
    }()
    lazy private var pageControl:HPageControl = {
        let one = HPageControl()
        one.numberOfPages = self.totalNum
        one.currentPage = 0
        return one
    }()
    init(frame: CGRect,source:[imageAbleConversion],title:[String]?) {
        super.init(frame: frame)
        totalNum =  source.count
        self.dataArray = source
        self.dataArray.insert(source.last!, atIndex: 0)
        self.dataArray.append(source[0])
        if let title = title{
            self.title=title
            self.title?.insert(title.last!, atIndex: 0)
            self.title?.append(title[0])
        }
        self.addSubview(self.mainView)
        self.addSubview(self.pageControl)
        self.mainView.contentOffset = CGPointMake(self.width, 0)
        self.setTimer()
    }
    func replacePageControl(pageControl:HPageControl){
        self.pageControl.removeFromSuperview()
        self.pageControl = pageControl
        self.pageControl.numberOfPages = self.totalNum
        self.pageControl.currentPage = currentIndex
        self.addSubview(self.pageControl)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit{
        UIImageCache.deleteOutTimeFile()
    }
}
/**主要实现功能*/
extension HScrollView{
    func setTimer(){
        self.deinitTimer()
        if(self.autoScroll){
            self.timer = NSTimer.scheduledTimerWithTimeInterval(self.autoScrollTime, target: self, selector:#selector(self.autoScroll(_:)), userInfo: nil, repeats: true)
        }
    }
    func deinitTimer(){
        self.timer?.invalidate()
        self.timer = nil
    }
    func autoScroll(time:NSTimer){
        self.mainView.setContentOffset(CGPointMake(self.mainView.contentOffset.x + self.width, 0), animated: true)
            self.adjustContent()
            self.adjustpageControl(true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.follow.itemSize = self.size
        if self.pageControl.center == CGPointZero {
            print("\(NSStringFromCGRect(self.pageControl.frame))")
            self.pageControl.center = CGPointMake(self.center.x, self.height - cellBottomLabelHeight-10)
        }
    }
    static func scrollView(frame:CGRect,source:[imageAbleConversion],title:[String]?)->HScrollView{
        let scrollV = HScrollView.init(frame: frame, source: source,title: title)
        return scrollV
    }
    //调整显示的内容
    func adjustContent(){
        let now:Int = Int(self.mainView.contentOffset.x / self.width)
        if(now==0){
            let point:CGPoint = CGPointMake(self.mainView.width * CGFloat(self.dataArray.count-2), 0)
            self.mainView.contentOffset = point
        }else if (now == self.dataArray.count-1){
            let point:CGPoint = CGPointMake(self.mainView.width, 0)
            self.mainView.contentOffset = point
        }
    }
    //调整pageControl
    func adjustpageControl(isAuto:Bool){
        if isAuto{
            var index = Int(self.mainView.contentOffset.x / self.width)
            if (index == totalNum){index = 0}
            self.pageControl.currentPage = index
        }else{
            let index = Int(self.mainView.contentOffset.x / self.width) - 1
            self.pageControl.currentPage = index
        }
    
    }
}
extension HScrollView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return totalNum + 2
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        if let _ = self.delegate{
            if self.delegate!.respondsToSelector(#selector(HScrollViewDelegate.HScrollViewWillShowCell(_:indexPath:))){
                let c = indexPath.row > totalNum ? 0 : (indexPath.row - 1)
                self.delegate!.HScrollViewWillShowCell!(self, indexPath: NSIndexPath.init(forRow:c, inSection: 0))
            }
        }
        let cell:HScrollCell = collectionView.dequeueReusableCellWithReuseIdentifier("HScrollCell", forIndexPath: indexPath) as! HScrollCell
        cell.setImage(self.dataArray[indexPath.row], title:self.title?[indexPath.row])
        return cell
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let _ = self.delegate{
            if self.delegate!.respondsToSelector(#selector(HScrollViewDelegate.HScrollViewDidTouchUp(_:indexPath:))){
                let c = indexPath.row > totalNum ? 0 : (indexPath.row - 1)
                self.delegate!.HScrollViewDidTouchUp!(self, indexPath:NSIndexPath.init(forRow:c, inSection: 0))
            }
        }
        
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.adjustContent()
        self.adjustpageControl(false)
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / self.width)
        self.deinitTimer()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.setTimer()
    }
}





