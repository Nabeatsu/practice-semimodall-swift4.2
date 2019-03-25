//
//  ViewController.swift
//  practice-semimodall-swift4.2
//
//  Created by 田辺信之 on 2019/03/25.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import UIKit
class TinyConstraintsViewController:UIViewController{
    
    private weak var moveView:UIView?
    private var showConstraint:NSLayoutConstraint?
    private var dismissConstraint:NSLayoutConstraint?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //制約をつける
        self.setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //状態遷移する
        self.transitState()
    }
}

extension TinyConstraintsViewController{
    
    func setup(){
        let moveView = UIView()
        self.view.addSubview(moveView)
        self.moveView = moveView
        moveView.translatesAutoresizingMaskIntoConstraints = false
        moveView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        moveView.heightAnchor.constraint(equalTo: moveView.widthAnchor).isActive = true
        moveView.backgroundColor = .red
        moveView.centerXAnchor.constraint(equalToSystemSpacingAfter: moveView.superview!.centerXAnchor, multiplier: 0).isActive = true
        
        //非表示の制約 最初はisActiveをfalseに
        self.dismissConstraint = moveView.topAnchor.constraint(equalToSystemSpacingBelow: moveView.superview!.bottomAnchor, multiplier: 0)
        self.dismissConstraint?.isActive = false
        //表示の制約 safeArea内
        self.showConstraint = moveView.topAnchor.constraint(equalTo: moveView.superview!.safeAreaLayoutGuide.topAnchor)
        showConstraint!.isActive = true
    }
    
    func transitState(){
        if self.showConstraint!.isActive {
            self.showConstraint!.isActive = false
            self.dismissConstraint?.isActive = true
        }
        else{
            self.dismissConstraint?.isActive = false
            self.showConstraint!.isActive = true
        }
        
        //1秒かけて制約の状態をviewに反映させる
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
        }
    }
}

