//
//  ZXTitleView.swift
//  ZXPageView
//
//  Created by Anthony on 2017/8/9.
//  Copyright © 2017年 Anthony. All rights reserved.
//

import UIKit

protocol ZXTitleViewDelegate:class {
    func titleView(_ titleView:ZXTitleView,currentIndex:Int)
}

class ZXTitleView: UIView {

    // weak:只能用来修饰对象
    weak var delegate : ZXTitleViewDelegate?
    
    fileprivate var style:ZXPageStyle
    fileprivate var titles:[String]
    fileprivate var currentIndex : Int = 0
    
    typealias ColorRGB = (red:CGFloat,green:CGFloat,blue:CGFloat)
    fileprivate lazy var selectRGB : ColorRGB = self.style.selectColor.getRGB()
    fileprivate lazy var normalRGB : ColorRGB = self.style.normalColor.getRGB()
    fileprivate lazy var deltaRGB : ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let deltaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()

    fileprivate lazy var titleButtons : [UIButton] = [UIButton]()
    fileprivate lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    fileprivate lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        return bottomLine
    }()
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverBgColor
        coverView.alpha = self.style.coverAlpha
        return coverView
    }()
    
    init(frame:CGRect,style:ZXPageStyle,titles:[String]) {
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        setupSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ZXTitleView{
    
    fileprivate func setupSubView(){
        
        //1.添加一个UIScrollView
        addSubview(scrollView)
        
        //2.创建所有的标题按钮
        setupTitleButtons()
        
        //3.设置button的frame
        setupButtonsFrame()
        
        // 4.设置bottomLine
        setupBottomLine()
        
        // 5.设置coverView
        setupCoverView()
        
    }
    
    
    private func setupTitleButtons(){
        
        for (i,title) in titles.enumerated() {
            
            //1.创建Label
            let button = UIButton()
            
             button.backgroundColor = UIColor.randomColor
            
            //2.设置label的属性
            button.tag = i
            button.setTitle(title, for: .normal)
            if i == 0{
                button.setTitleColor(style.selectColor, for: .normal)
            }else{
                button.setTitleColor(style.normalColor, for: .normal)
            }
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = UIFont.systemFont(ofSize:style.fontSize)
            //3.将label添加到scrollView中
            scrollView.addSubview(button)
            
            //4.将label添加到数组中
            titleButtons.append(button)
            
            //5.监听label的点击
            button.addTarget(self, action: #selector(titleButtonClick(_:)), for: .touchUpInside)
        }
        
    }
    
    
    private func setupButtonsFrame(){
        
        //1.定义出变量&常量
        let buttonH = style.titleHeight
        let buttonY:CGFloat = 0
        var buttonW:CGFloat = 0
        var buttonX:CGFloat = 0
        
        //2.设置titlelabel的frame
        let count = titleButtons.count
        for (i,titleButton) in titleButtons.enumerated() {
            if style.isScrollEnable {
                
                //FIXME: - 这里的font怎么是个可选的？
                let font = titleButton.titleLabel!.font!
              
                let attributes = [NSAttributedStringKey.font:font]
                
                let string = titles[i] as NSString
                
                let size = CGSize(width:CGFloat.greatestFiniteMagnitude,height:0)
                
                buttonW =  string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).width
                
//                buttonW = (titles[i] as NSString).boundingRect(with: CGSize(width:CGFloat.greatestFiniteMagnitude,height:0), options: .usesLineFragmentOrigin, attributes:attributes , context: nil).width
                buttonX = i == 0 ? style.titleMargin * 0.5 : (titleButtons[i - 1].frame.maxX + style.titleMargin)
            }else{
                buttonW = bounds.width / CGFloat(count)
                buttonX = buttonW * CGFloat(i)
            }
            titleButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonW, height: buttonH)
        }
        
        //设置scale属性
        if style.isScaleEnable {
            titleButtons.first?.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
        
        
        //3.设置contentSize
        if style.isScrollEnable {
            scrollView.contentSize.width = titleButtons.last!.frame.maxX + style.titleMargin * 0.5
        }
    }
    
    
    private func setupBottomLine(){
    
        //1.判断是否需要显示BottomLine
        guard style.isShowBottomLine else {
            return
        }
        
        //2.将bottomLine添加到scrollView中
        scrollView.addSubview(bottomLine)
        
        // 3.设置bottomLine的frame中的属性
        let button = titleButtons.first!
        button.titleLabel?.sizeToFit()
        bottomLine.frame.size.width = button.titleLabel!.frame.size.width
        bottomLine.center.x = button.center.x
    }

    
    
    private func setupCoverView(){
        
        // 1.判断是否需要显示coverView
        guard style.isShowCoverView  else { return  }
        
        
        // 2.添加到scrollView
        scrollView.insertSubview(coverView, at: 0)
        
        // 3.设置遮盖的frame
        let firstLabel = titleButtons.first!
        var coverW = firstLabel.bounds.width
        let coverH = style.coverHeight
        var coverX = firstLabel.frame.origin.x
        let coverY = (firstLabel.frame.height - coverH) * 0.5
        if style.isScrollEnable {
            coverX -= style.coverMargin
            coverW += 2 * style.coverMargin
        }
        
        coverView.frame = CGRect(x: coverX, y: coverY, width: coverW, height: coverH)
        
        // 4.设置圆角
        coverView.layer.cornerRadius = style.coverRadius
        coverView.layer.masksToBounds = true
        
        
        
    }
    

}

extension ZXTitleView{

    @objc fileprivate func titleButtonClick(_ targetButton:UIButton){
        
        //1.校验button
        guard targetButton.tag != currentIndex else {  return  }
        
        //2.取出原来的label
        let sourceButton = titleButtons[currentIndex]
        
        //3.改变label的颜色
        sourceButton.setTitleColor(style.normalColor, for: .normal)
        targetButton.setTitleColor(style.selectColor, for: .normal)
    
        //4.记录最新的index
        currentIndex = targetButton.tag
        
        //5.让点击的label居中显示
        adjustLabelPosition(targetButton)
        
        //6.通知代理
        delegate?.titleView(self, currentIndex: currentIndex)
        
        // 7.调整scale缩放
        if style.isScaleEnable {
            UIView.animate(withDuration: 0.25, animations: { 
                sourceButton.transform = CGAffineTransform.identity
                targetButton.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        //8.调整bottomLine
        if style.isShowBottomLine {
            
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.size.width = targetButton.titleLabel!.frame.size.width
                self.bottomLine.center.x = targetButton.center.x
            })
        }
        
        // 9.调整CoverView
        if style.isShowCoverView {
            let coverX = style.isScrollEnable ? (targetButton.frame.origin.x - style.coverMargin) : targetButton.frame.origin.x
            let coverW = style.isScrollEnable ? (targetButton.frame.width + style.coverMargin * 2) : targetButton.frame.width
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }

        
    }
    
    fileprivate func setTargetLabel(_ targetButton:UIButton){
        // 1.取出原来的label
        let sourceButton = titleButtons[currentIndex]
        
        // 2.改变Label的颜色
        sourceButton.setTitleColor(style.selectColor, for: .normal)
        targetButton.setTitleColor(style.normalColor, for: .normal)
        
        // 3.记录最新的index
        currentIndex = targetButton.tag
        
        // 4.让点击的label居中显示
        adjustLabelPosition(targetButton)
        
        // 5.调整scale缩放
        // transform : frame.wh = bounds.wh * transform的值
        if style.isScaleEnable {
            UIView.animate(withDuration: 0.25, animations: {
                sourceButton.transform = CGAffineTransform.identity
                targetButton.transform = CGAffineTransform(scaleX: self.style.maxScale, y: self.style.maxScale)
            })
        }
        
        // 6.调整bottomLine
        if style.isShowBottomLine {
            UIView.animate(withDuration: 0.25, animations: {
                self.bottomLine.frame.origin.x = targetButton.frame.origin.x
                self.bottomLine.frame.size.width = targetButton.frame.width
            })
        }
        
        // 7.调整CoverView
        if style.isShowCoverView {
            let coverX = style.isScrollEnable ? (targetButton.frame.origin.x - style.coverMargin) : targetButton.frame.origin.x
            let coverW = style.isScrollEnable ? (targetButton.frame.width + style.coverMargin * 2) : targetButton.frame.width
            UIView.animate(withDuration: 0.15, animations: {
                self.coverView.frame.origin.x = coverX
                self.coverView.frame.size.width = coverW
            })
        }
    }
    
    fileprivate func adjustLabelPosition(_ targetButton:UIButton){
    
        //0.只有可以滚动的时候可以调整
        guard style.isScrollEnable else {
            return
        }
        
        //1.计算offsetX
        var offsetX = targetButton.center.x - bounds.width * 0.5
        
        //2.临界值判断
        if offsetX < 0 {
            offsetX = 0
        }
        
        if offsetX > scrollView.contentSize.width - scrollView.bounds.width {
            offsetX = scrollView.contentSize.width - scrollView.bounds.width
        }
        
        //3.设置scrollView的contentOffset
        scrollView.setContentOffset(CGPoint(x:offsetX,y:0), animated: true)
    }

}


extension ZXTitleView :ZXContentViewDelegate{

    func contentView(_ contentView: ZXContentView, inIndex: Int) {
        
        //1.记录最新的currentIndex
        currentIndex = inIndex
        
        //2.让targetLabel居中显示
        adjustLabelPosition(titleButtons[currentIndex])
    }
    
    
    func contentView(_ contentView: ZXContentView, sourceIndex: Int, targetIndex: Int, progress: CGFloat) {

        
        //1.获取sourceLabel&targetLabel
        let sourceButton = titleButtons[sourceIndex]
        let targetButton = titleButtons[targetIndex]
        

        //2.字体颜色的渐变
        let sourceColor = UIColor(r: selectRGB.red - progress * deltaRGB.red, g: selectRGB.green - progress * deltaRGB.green, b: selectRGB.blue - progress * deltaRGB.blue)
        sourceButton.setTitleColor(sourceColor, for: .normal)
        let targetColor = UIColor(r: normalRGB.red + progress * deltaRGB.red, g: normalRGB.green + progress * deltaRGB.green, b: normalRGB.blue + progress * deltaRGB.blue)
        targetButton.setTitleColor(targetColor, for: .normal)
        
        
        // 3.scale的调整
        if style.isScaleEnable {
            let deltaScale = style.maxScale - 1.0
            sourceButton.transform = CGAffineTransform(scaleX: style.maxScale - progress * deltaScale, y: style.maxScale - progress * deltaScale)
            targetButton.transform = CGAffineTransform(scaleX: 1.0 + progress * deltaScale, y: 1.0 + progress * deltaScale)
        }
        
        // 4.bottomLine的调整
        if style.isShowBottomLine {
            
            //4.1计算x值
            let deltaX = targetButton.frame.origin.x - sourceButton.frame.origin.x
             bottomLine.frame.origin.x = sourceButton.frame.origin.x + progress * deltaX
            
            //4.2计算宽度
            let deltaW = targetButton.frame.width - sourceButton.frame.width
            bottomLine.frame.size.width = sourceButton.frame.width + progress * deltaW

        }
        
        
        // 5.coverView的调整
        if style.isShowCoverView {
            let deltaX = targetButton.frame.origin.x - sourceButton.frame.origin.x
            let deltaW = targetButton.frame.width - sourceButton.frame.width
            coverView.frame.size.width = style.isScrollEnable ? (sourceButton.frame.width + 2 * style.coverMargin + deltaW * progress) : (sourceButton.frame.width + deltaW * progress)
            coverView.frame.origin.x = style.isScrollEnable ? (sourceButton.frame.origin.x - style.coverMargin + deltaX * progress) : (sourceButton.frame.origin.x + deltaX * progress)
        }
    }
    
}


// MARK: - 对外提供的方法
extension ZXTitleView{
    func setCurrentIndex(currentIndex:Int)  {
        setTargetLabel(titleButtons[currentIndex])
    }
}
