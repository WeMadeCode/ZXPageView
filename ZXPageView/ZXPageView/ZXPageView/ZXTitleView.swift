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

    /// weak:只能用来修饰对象
    weak var delegate : ZXTitleViewDelegate?
    
    fileprivate var style:ZXPageStyle
    fileprivate var titles:[String]
    fileprivate var currentIndex : Int = 0
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = self.bounds
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    
    //MARK:构造函数
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
    
    fileprivate  func setupSubView(){
        
        //1.添加一个UIScrollView
        addSubview(scrollView)
        
        //2.设置所有的标题
        setupTitleLabels()
        
        //3.设置label的frame
        setupLabelsFrame()
        
    }
    
    private func setupTitleLabels(){
        
        for (i,title) in titles.enumerated() {
            
            //1.创建Label
            let label = UILabel()
            
            //2.设置label的属性
            label.tag = i
            label.text = title
            label.textColor = i == 0 ? style.selectColor : style.normalColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: style.fontSize)
            
            //3.将label添加到scrollView中
            scrollView.addSubview(label)
            
            //4.将label添加到数组中
            titleLabels.append(label)
            
            //5.监听label的点击
            //事件监听依然是发送消息
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            label.addGestureRecognizer(tapGes)
            label.isUserInteractionEnabled = true
            
        }
    
    }
    
    
    private func setupLabelsFrame(){
        
        //1.定义出变量&常量
        let labelH = style.titleHeight
        let labelY:CGFloat = 0
        var labelW:CGFloat = 0
        var labelX:CGFloat = 0
        
        //2.设置titlelabel的frame
        let count = titleLabels.count
        for (i,titlelabel) in titleLabels.enumerated() {
            if style.isScrollEnable {
                
                labelW = (titles[i] as NSString).boundingRect(with: CGSize(width:CGFloat.greatestFiniteMagnitude,height:0), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName
                    :titlelabel.font], context: nil).width
                
                labelX = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i - 1].frame.maxX + style.titleMargin)
                
            }else{
                
                labelW = bounds.width / CGFloat(count)
                labelX = labelW * CGFloat(i)
            
            }
            
            titlelabel.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
        }
        
        //3.设置contentSize
        if style.isScrollEnable {
            scrollView.contentSize.width = titleLabels.last!.frame.maxX + style.titleMargin * 0.5
        }
        
        
        
    
    }

}

extension ZXTitleView{

    /*
     tapGes:外部参数
     @objc 如果在函数前加载@objc，那么会保留OC的特性
     OC在调用方法时，本质是发送消息
     将方法包装成@SEL -> 根据@SEL去类中的方法映射表 -> IMP指针
     目的：灵活 -> 不安全
     */
    @objc fileprivate func titleLabelClick(_ tapGes:UITapGestureRecognizer){
        
        //1.校验UILabel
        guard let targetLabel = tapGes.view as? UILabel else { return }
       
        guard targetLabel.tag != currentIndex else {  return  }
        
        //2.取出原来的label
        let sourceLabel = titleLabels[currentIndex]
        
        //3.改变Label的颜色
        sourceLabel.textColor = style.normalColor
        targetLabel.textColor = style.selectColor
        
        //4.记录最新的index
        currentIndex = targetLabel.tag
        
        //5.让点击的label居中显示
        adjustLabelPosition(targetLabel)
        
        //6.通知代理
        delegate?.titleView(self, currentIndex: currentIndex)

        
    }
    
    
    private func adjustLabelPosition(_ targetLabel:UILabel){
    
        //1.计算offsetX
        var offsetX = targetLabel.center.x - bounds.width * 0.5
        
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

