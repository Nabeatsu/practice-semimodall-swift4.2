//
//  ViewController.swift
//  practice-semimodall-swift4.2
//
//  Created by 田辺信之 on 2019/03/25.
//  Copyright © 2019 田辺信之. All rights reserved.
//

import UIKit
import TinyConstraints

class ViewController:UIViewController{
    
    var modalView:ModalView?=nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        //モーダルビューをセット
        let modalView = ModalView()
        self.view.addSubview(modalView)
        self.modalView = modalView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let modalView = self.modalView else { return }
        //非表示、非表示を切り替える
        if modalView.isShowing {
            modalView.hide()
        }
        else{
            modalView.show()
        }
    }
}
