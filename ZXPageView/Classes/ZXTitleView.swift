//
//  ZXTitleView.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

@objc public protocol ZXTitleViewDelegate:class {
    /// 点击当前按钮
    ///
    /// - Parameters:
    ///   - titleView: titleView
    ///   - currentTitle: 当前标题
    ///   - currentIndex: 当前标记
    @objc optional func titleView(_ titleView:ZXTitleView,currentTitle:String,currentIndex:Int)
    /// 点击下一个按钮
    ///
    /// - Parameters:
    ///   - titleView: titleView
    ///   - nextTitle: 下一个标题
    ///   - nextIndex: 下一个标记
    func titleView(_ titleView:ZXTitleView,nextTitle:String,nextIndex:Int)
}

public class ZXTitleView: UIView {
    private  let defaultIndex : Int
    public   weak var delegate : ZXTitleViewDelegate?
    private  var style:ZXPageStyle
    private  var titles:[String]
    private  var currentIndex : Int = 0
    typealias ColorRGB = (red:CGFloat,green:CGFloat,blue:CGFloat)
    private lazy var selectRGB : ColorRGB = self.style.selectColor.getRGB()
    private lazy var normalRGB : ColorRGB = self.style.normalColor.getRGB()
    private lazy var deltaRGB : ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let deltaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()
    private lazy var titleButtons  = [UIButton]()
    private lazy var titleButtonWs = [CGFloat]()
    private lazy var titleScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    private lazy var bottomLine: UIView = {
        let line = UIView()
        line.backgroundColor = self.style.bottomLineColor
        line.frame.size.height = self.style.bottomLineHeight
        line.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        line.layer.cornerRadius = self.style.cornerRadius
        return line
    }()
    private lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = self.style.coverAlpha
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
        return coverView
    }()
    
    public init(frame:CGRect,style:ZXPageStyle,titles:[String],defaultIndex:Int = 0) {
        self.defaultIndex = defaultIndex
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        setupSubView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ZXTitleView{
    
    private func setupSubView(){
        // 1.添加一个UIScrollView
        addSubview(titleScrollView)
        
        // 2.清空操作
        initSubData()
        
        // 3.创建所有的标题按钮
        setupTitleButtons()
        
        // 4.计算所有按钮的frame
        setupButtonsFrame()
        
        // 5.设置bottomLine
        setupBottomLine()
        
        // 6.设置coverView
        setupCoverView()
        
        // 7.设置默认滚动位置
        setDefaultContent()
    }
    
    
    func initSubData(){
        //1.清空子控件
        titleScrollView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        titleScrollView.contentSize.width = 0
        
        //2.清空数组
        titleButtons.removeAll()
        titleButtonWs.removeAll()
        currentIndex = 0
    }
    
    private func setupTitleButtons(){
        for (i,title) in titles.enumerated() {
            //1.创建UIbutton
            let button = UIButton()
            
            //2.设置button的属性
            button.tag = i
            button.setTitle(title, for: .normal)
            if i == 0{
                button.setTitleColor(style.selectColor, for: .normal)
            }else{
                button.setTitleColor(style.normalColor, for: .normal)
            }
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = UIFont.systemFont(ofSize:style.fontSize)
     
            //3.将button添加到数组中
            titleButtons.append(button)
            
            //4.监听button的点击
            button.addTarget(self, action: #selector(titleButtonClick(_:)), for: .touchUpInside)
        }
    }
    
    
   private func setupButtonsFrame(){
        //计算按钮总宽度
        let totalWidth = self.calculateTotalWidth()
        
        if totalWidth > bounds.width { //总宽度大于屏幕宽度，按间距布局
            //允许滚动
            titleScrollView.isScrollEnabled = true
            self.dividedByDistance()
        }else{ //总宽度小于屏幕宽度
            //禁止滚动
             titleScrollView.isScrollEnabled = false
            if style.isDivideByScreen == true{//按等分屏幕布局
                self.dividedByScreen()
            }else{ //任然按照间距布局
                self.dividedByDistance()
            }
        }

        //设置scale属性
        if style.isScaleEnable {
            titleButtons.first?.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
        
        
        //3.设置contentSize
        if titleScrollView.isScrollEnabled {
            titleScrollView.contentSize.width = titleButtons.last!.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    
    private func calculateTotalWidth() -> CGFloat{
        //1.定义变量
        var totalWidth : CGFloat = CGFloat(titleButtons.count) * style.titleMargin
        
        //2.计算按钮的frame
        for (i,titleButton) in titleButtons.enumerated() {
            //计算所有按钮的width
            let attributes = [NSAttributedString.Key.font:titleButton.titleLabel!.font!]
            let string = titles[i] as NSString
            let size = CGSize(width:CGFloat.greatestFiniteMagnitude,height:0)
            let buttonW =  string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).width
            totalWidth = totalWidth + buttonW
            self.titleButtonWs.append(buttonW)
            
            //将button添加到scrollView中
            titleScrollView.addSubview(titleButton)
        }
        return totalWidth
    }
    
    private func dividedByScreen()  {
        for (i,_) in titleButtonWs.enumerated(){
            let averageWidth = bounds.width / CGFloat(titleButtons.count)
            let buttonX = averageWidth * CGFloat(i)
            let titleButton = titleButtons[i]
            titleButton.frame = CGRect(x: buttonX, y: 0, width: averageWidth, height: style.titleHeight)
        }
    }
    
    private func dividedByDistance(){
        for (i,width) in titleButtonWs.enumerated(){
            let buttonX:CGFloat = i == 0 ? style.titleMargin * 0.5 : (titleButtons[i - 1].frame.maxX + style.titleMargin)
            let buttonW:CGFloat = width
            let titleButton = titleButtons[i]
            titleButton.frame = CGRect(x: buttonX, y: 0, width: buttonW, height: style.titleHeight)
        }
    }
    
    private func setupBottomLine(){
        
        //1.判断是否需要显示BottomLine
        guard style.isShowBottomLine else { return }
        
        //2.将bottomLine添加到scrollView中
        titleScrollView.addSubview(bottomLine)
        
        // 3.设置bottomLine的frame中的属性
        let button = titleButtons.first!
        button.titleLabel?.sizeToFit()
        if style.isLongStyle{
            bottomLine.frame.size.width = button.frame.size.width
        }else{
            bottomLine.frame.size.width = button.titleLabel!.frame.size.width
        }
        bottomLine.center.x = button.center.x
    }

    
    private  func setupCoverView(){
        
        // 判断是否需要显示单个背景图
        if style.isShowCoverView {
            // 添加到scrollView
            titleScrollView.insertSubview(coverView, at: 0)
            
            // 重新计算按钮的x值
            titleButtons.forEach { (btn) in
                btn.frame.origin.x += style.coverMargin
            }
            
            // 计算cover的frame
            let firstButton = titleButtons.first!
            let coverW = firstButton.bounds.width + 2 * style.coverMargin
            let coverH = style.coverHeight
            let coverX = firstButton.frame.origin.x - style.coverMargin
            let coverY = (firstButton.frame.height - coverH) * 0.5
            coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
            
            // 更新contenSize
            if titleScrollView.isScrollEnabled == true{
                titleScrollView.contentSize.width += 2 * style.coverMargin
            }
            
        }else if style.isShowEachView { //判断是否需要显示全部背景图
            titleButtons.forEach { (btn) in
                //创建coverView
                let coverView = UIView()
                coverView.backgroundColor = self.style.coverBgColor
                coverView.alpha = self.style.coverAlpha
                coverView.layer.cornerRadius = style.coverRadius
                coverView.layer.masksToBounds = true
                
                //添加到scrollView
                titleScrollView.insertSubview(coverView, at: 0)
                
                //重新计算按钮的x值
                btn.frame.origin.x += style.coverMargin
                
                // 计算cover的frame
                let coverW = btn.bounds.width + 2 * style.coverMargin
                let coverH = style.coverHeight
                let coverX = btn.frame.origin.x - style.coverMargin
                let coverY = (btn.frame.height - coverH) * 0.5
                coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
            }
            
            // 更新contenSize
            if titleScrollView.isScrollEnabled == true{
                titleScrollView.contentSize.width += 2 * style.coverMargin
            }
        }
        

    }

    
    // 设置默认滚动位置
    private func setDefaultContent()  {
        if defaultIndex >= 0 && defaultIndex <= titles.count{
            
            // 1.取出目标按钮
            let targetButton = titleButtons[defaultIndex]
            
            // 2.取出原来的按钮
            let sourceButton = titleButtons[currentIndex]
            
            // 3.改变按钮的颜色
            sourceButton.setTitleColor(style.normalColor, for: .normal)
            targetButton.setTitleColor(style.selectColor, for: .normal)
            
            // 4.记录最新的index
            currentIndex = targetButton.tag
            
            // 5.让点击的按钮居中显示
            adjustButtonPosition(targetButton)
            
            // 6.设置动画
            setStyleAnimated(sourceButton,targetButton)
        }

    }
}

extension ZXTitleView{
    
     @objc private func titleButtonClick(_ targetButton:UIButton){
    
        // 1.取出原来的按钮
        let sourceButton = titleButtons[currentIndex]
        
        // 2.通知外界点击了当前按钮
        if targetButton.tag == currentIndex{
            self.delegate?.titleView?(self, currentTitle: sourceButton.currentTitle ?? "", currentIndex: currentIndex)
            return
        }
       
        // 3.改变按钮的颜色
        sourceButton.setTitleColor(style.normalColor, for: .normal)
        targetButton.setTitleColor(style.selectColor, for: .normal)
        
        // 4.记录最新的index
        currentIndex = targetButton.tag
        
        // 5.让点击的按钮居中显示
        adjustButtonPosition(targetButton)
        
        // 6.设置动画
        setStyleAnimated(sourceButton,targetButton)
        
        // 7.通知外界点击了下一个按钮
        delegate?.titleView(self, nextTitle: targetButton.currentTitle ?? "", nextIndex: currentIndex)
    }
    
    private func setStyleAnimated(_ sourceButton:UIButton, _ targetButton:UIButton){
        // 1.调整scale缩放
        if style.isScaleEnable {
            UIView.animate(withDuration: 0.25, animations: {
                sourceButton.transform = CGAffineTransform.identity
                targetButton.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        //2.调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                if self.style.isLongStyle{
                    self.bottomLine.frame.size.width = targetButton.frame.size.width
                }else{
                    self.bottomLine.frame.size.width = targetButton.titleLabel!.frame.size.width
                }
                self.bottomLine.center.x = targetButton.center.x
            })
        }
        
        // 3.调整CoverView
        if style.isShowCoverView {
            let coverX = targetButton.frame.origin.x - style.coverMargin
            let coverW = targetButton.frame.width + style.coverMargin * 2
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
    }
    
   
    private func setStyleAnimatedProgressed(_ sourceButton:UIButton, _ targetButton:UIButton,_ progress:CGFloat){
        // 1.字体颜色的渐变
        let sourceColor = UIColor(r: selectRGB.red - progress * deltaRGB.red, g: selectRGB.green - progress * deltaRGB.green, b: selectRGB.blue - progress * deltaRGB.blue)
        sourceButton.setTitleColor(sourceColor, for: .normal)
        let targetColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)
        targetButton.setTitleColor(targetColor, for: .normal)
        
        // 2.scale的调整
        if style.isScaleEnable {
            let deltaScale = style.maxScale - 1.0
            sourceButton.transform = CGAffineTransform(scaleX: style.maxScale - progress * deltaScale, y: style.maxScale - progress * deltaScale)
            targetButton.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale, y: 1.0 + progress * deltaScale)
        }
        
        // 3.bottomLine的调整
        if style.isShowBottomLine {
            //4.1计算宽度
            let deltaW = targetButton.titleLabel!.frame.width - sourceButton.titleLabel!.frame.width
            if style.isLongStyle{
                bottomLine.frame.size.width = sourceButton.frame.size.width + progress * deltaW
            }else{
                bottomLine.frame.size.width = sourceButton.titleLabel!.frame.width + progress * deltaW
            }
            
            //4.2计算x值
            let deltaX = targetButton.center.x - sourceButton.center.x
            bottomLine.center.x = sourceButton.center.x + progress * deltaX
        }
        
        
        // 4.coverView的调整
        if style.isShowCoverView {
            let deltaX = targetButton.frame.origin.x - sourceButton.frame.origin.x
            let deltaW = targetButton.frame.width - sourceButton.frame.width
            coverView.frame.size.width = sourceButton.frame.width + 2 * style.coverMargin + deltaW * progress
            coverView.frame.origin.x = sourceButton.frame.origin.x - style.coverMargin + deltaX * progress
        }
        
    }
    
    private func adjustButtonPosition(_ targetButton:UIButton){
        //0.只有可以滚动的时候可以调整
        guard titleScrollView.isScrollEnabled else {  return  }
        
        //1.计算offsetX
        var offsetX = targetButton.center.x - bounds.width * 0.5
        
        //2.临界值判断
        if offsetX < 0 {
            offsetX = 0
        }
        
        if offsetX > titleScrollView.contentSize.width - titleScrollView.bounds.width {
            offsetX = titleScrollView.contentSize.width - titleScrollView.bounds.width
        }
        
        //3.设置scrollView的contentOffset
        titleScrollView.setContentOffset(CGPoint(x:offsetX,y:0), animated: true)
    }

}



// MARK: - 给外界使用的方法
extension ZXTitleView{
   public func setCurrentIndex(_ currentIndex:Int)  {
        titleButtonClick(titleButtons[currentIndex])
    }
    
    
   public func setCurrentProgress(sourceIndex: Int, targetIndex: Int, progress: CGFloat) {
        self.setStyleAnimatedProgressed(titleButtons[sourceIndex], titleButtons[targetIndex], progress)
    }
    
    
    /// 单独使用titleView的时候使用
    ///
    /// - Parameter titles: 需要更新的新数据源
    public func updateTitles(_ titles:[String]){
       
        self.titles = titles
        
        self.setupSubView()
    }
    
}
