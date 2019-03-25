//
//  ModalView.swift
//  practice-semimodall-swift4.2
//
//  Created by 田辺信之 on 2019/03/25.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import UIKit
import TinyConstraints

class ModalView: UIView {
    
    var isShowing:Bool = false
    
    private weak var backgroundView:UIView?
    private weak var slideView:UIView?
    private weak var safeAreaView:UIView?
    
    private var showConstraint:Constraint?
    private var dismissConstraint:Constraint?
    
    convenience init() {self.init(frame: UIScreen.main.bounds)}
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        //windowに貼り付けたあとに制約をつける
        self.centerInSuperview()
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setup() {
        //自身のサイズ
        self.backgroundColor = .clear
        self.alpha = 0
        self.size(UIScreen.main.bounds.size)
        
        //背景をブラックアウトさせるview
        let backgroundView = UIView()
        self.addSubview(backgroundView)
        self.backgroundView = backgroundView
        backgroundView.edgesToSuperview()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        //スライドさせるview
        let slideView = UIView()
        self.addSubview(slideView)
        self.slideView = slideView
        slideView.backgroundColor = .clear
        slideView.size(to: self)
        slideView.centerXToSuperview()
        //表示の制約
        self.dismissConstraint = slideView.topToBottom(of: self)
        //非表示の制約
        self.showConstraint = slideView.topToSuperview(isActive: false)
        do{
            //セーフエリア内のview
            let safeAreaView = UIView()
            slideView.addSubview(safeAreaView)
            self.safeAreaView = safeAreaView
            safeAreaView.layer.masksToBounds = true
            if #available(iOS 11.0, *) {
                safeAreaView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            } else {
                // Fallback on earlier versions
            }
            safeAreaView.layer.cornerRadius = 40.0
            safeAreaView.backgroundColor = .red
            safeAreaView.widthToSuperview(offset:-14)
            safeAreaView.centerXToSuperview()
            safeAreaView.bottomToSuperview(usingSafeArea:true)
            safeAreaView.topToSuperview(usingSafeArea:true)
            
            //セーフエリア内にコンテンツを入れる
            self.setMainContents(mainView: safeAreaView)
            
            //セーフエリアの外のview
            let bottomAreaView = UIView()
            slideView.addSubview(bottomAreaView)
            bottomAreaView.backgroundColor = safeAreaView.backgroundColor
            bottomAreaView.width(to: safeAreaView)
            bottomAreaView.centerXToSuperview()
            bottomAreaView.topToBottom(of: safeAreaView)
            bottomAreaView.bottomToSuperview()
        }
    }
    
    func show(_ animated:Bool = true, complition:(()->())? = nil) {
        self.alpha = 1
        //表示と非表示の制約を入れ替える
        self.dismissConstraint?.isActive = false
        self.showConstraint?.isActive = true
        let duration = animated ? 0.4 : 0.0
        UIView.animate(withDuration: duration, animations: {
            self.backgroundView?.alpha = 1
            self.layoutIfNeeded()
        }) { (isComp) in
            self.isShowing = true
            complition?()
        }
    }
    
    func hide(_ animated:Bool=true, complition:(()->())? = nil) {
        //表示と非表示の制約を入れ替える
        self.showConstraint?.isActive = false
        self.dismissConstraint?.isActive = true
        let duration = animated ? 0.4 : 0.0
        UIView.animate(withDuration: duration, animations: {
            self.backgroundView?.alpha = 0
            self.layoutIfNeeded()
        }) { (isComp) in
            self.alpha = 0
            self.isShowing = false
            complition?()
        }
    }
    
    private func setMainContents(mainView:UIView?){
        guard let mainView = mainView else { return }
        
        let topLabel = UILabel()
        mainView.addSubview(topLabel)
        topLabel.backgroundColor = .white
        topLabel.text = "モーダルの一番上だよ"
        topLabel.sizeToFit()
        topLabel.centerXToSuperview()
        topLabel.topToSuperview()
        
        let bottomLabel = UILabel()
        mainView.addSubview(bottomLabel)
        bottomLabel.backgroundColor = .white
        bottomLabel.text = "モーダルの一番下だよ"
        bottomLabel.sizeToFit()
        bottomLabel.centerXToSuperview()
        bottomLabel.bottomToSuperview()
    }
}
