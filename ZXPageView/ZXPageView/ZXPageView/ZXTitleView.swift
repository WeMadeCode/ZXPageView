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

public class ZXTitleView: UIView {

    weak var delegate : ZXTitleViewDelegate?
    private var style:ZXPageStyle
    private var titles:[String]
    private var currentIndex : Int = 0
    typealias ColorRGB = (red:CGFloat,green:CGFloat,blue:CGFloat)
    private lazy var selectRGB : ColorRGB = self.style.selectColor.getRGB()
    private lazy var normalRGB : ColorRGB = self.style.normalColor.getRGB()
    private lazy var deltaRGB : ColorRGB = {
        let deltaR = self.selectRGB.red - self.normalRGB.red
        let deltaG = self.selectRGB.green - self.normalRGB.green
        let deltaB = self.selectRGB.blue - self.normalRGB.blue
        return (deltaR, deltaG, deltaB)
    }()

    private lazy var titleButtons : [UIButton] = [UIButton]()
    private lazy var titleButtonWs : [CGFloat] = [CGFloat]()
    private lazy var titleScrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.backgroundColor = UIColor.white
        scrollView.isScrollEnabled = false
        return scrollView
    }()
    private lazy var bottomLine: UIView = {
        let bottomLine = UIView()
        bottomLine.backgroundColor = self.style.bottomLineColor
        bottomLine.frame.size.height = self.style.bottomLineHeight
        bottomLine.frame.origin.y = self.bounds.height - self.style.bottomLineHeight
        return bottomLine
    }()

    
    public init(frame:CGRect,style:ZXPageStyle,titles:[String]) {
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
        
        //1.添加一个UIScrollView
        addSubview(titleScrollView)
        
        //2.创建所有的标题按钮
        setupTitleButtons()
        
        //3.计算所有按钮的frame
        setupButtonsFrame()
        
        // 4.设置bottomLine
        setupBottomLine()
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
        
        //1.定义变量
        let count = titleButtons.count
        var totalWidth : CGFloat = CGFloat(count) * style.titleMargin

        //2.计算按钮的frame
        for (i,titleButton) in titleButtons.enumerated() {
            
            //计算所有按钮的width
            let attributes = [NSAttributedStringKey.font:titleButton.titleLabel!.font!]
            let string = titles[i] as NSString
            let size = CGSize(width:CGFloat.greatestFiniteMagnitude,height:0)
            let buttonW =  string.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).width
            totalWidth = totalWidth + buttonW
            self.titleButtonWs.append(buttonW)
            
            
            //默认为均分屏幕,不可以滚动
            let averageWidth = bounds.width / CGFloat(count)
            let buttonX = averageWidth * CGFloat(i)
            titleButton.frame = CGRect(x: buttonX, y: 0, width: averageWidth, height: style.titleHeight)
            
            //将button添加到scrollView中
            titleScrollView.addSubview(titleButton)
        }
        
        
        
        if totalWidth > bounds.width { //需要强行滚动
            
            for (i,width) in titleButtonWs.enumerated(){
                //修改frame
                let buttonX:CGFloat = i == 0 ? style.titleMargin * 0.5 : (titleButtons[i - 1].frame.maxX + style.titleMargin)
                let buttonW:CGFloat = width
                let titleButton = titleButtons[i]
                titleButton.frame = CGRect(x: buttonX, y: 0, width: buttonW, height: style.titleHeight)
                
            }
            titleScrollView.isScrollEnabled = true
            
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
    
    
    private func setupBottomLine(){
    
        //1.判断是否需要显示BottomLine
        guard style.isShowBottomLine else {
            return
        }
        
        //2.将bottomLine添加到scrollView中
        titleScrollView.addSubview(bottomLine)
        
        // 3.设置bottomLine的frame中的属性
        let button = titleButtons.first!
        button.titleLabel?.sizeToFit()
        bottomLine.frame.size.width = button.titleLabel!.frame.size.width
        bottomLine.center.x = button.center.x
    }

    
    
    func setDefaultConetnt(index:Int)  {
        
        let button = titleButtons[index]
        button.titleLabel?.sizeToFit()
        titleButtonClick(button)
    }

}

extension ZXTitleView{

    @objc private func titleButtonClick(_ targetButton:UIButton){
        
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
    }
    
    private func setTargetLabel(_ targetButton:UIButton){
        // 1.取出原来的label
        let sourceButton = titleButtons[currentIndex]
        
        // 2.改变Label的颜色
        sourceButton.setTitleColor(style.normalColor, for: .normal)
        targetButton.setTitleColor(style.selectColor, for: .normal)
        
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
        

    }
    
    private func adjustLabelPosition(_ targetButton:UIButton){
    
        //0.只有可以滚动的时候可以调整
        guard titleScrollView.isScrollEnabled else {
            return
        }
        
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
            //4.1计算宽度
            let deltaW = targetButton.titleLabel!.frame.width - sourceButton.titleLabel!.frame.width
            bottomLine.frame.size.width = sourceButton.titleLabel!.frame.width + progress * deltaW
            
            //4.2计算x值
            let deltaX = targetButton.center.x - sourceButton.center.x
            bottomLine.center.x = sourceButton.center.x + progress * deltaX
        }
    }
    
}


// MARK: - 对外提供的方法
extension ZXTitleView{
    func setCurrentIndex(currentIndex:Int)  {
        setTargetLabel(titleButtons[currentIndex])
    }
}
