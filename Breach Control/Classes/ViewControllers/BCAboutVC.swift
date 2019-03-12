//
//  BCAboutVC.swift
//  Breach Control
//
//  Created by naga on 2/19/19.
//  Copyright © 2019 Silent Quadrant. All rights reserved.
//

import UIKit
class BCAboutVC: BCBaseVC {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btnPrivacy: UIView!
    @IBOutlet weak var btnProviders: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailHeaderView: UIView!
    @IBOutlet weak var txtDetailHeader: UILabel!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let screenSize = UIScreen.main.bounds.size
        var topLayoutY: CGFloat = 0.0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topLayoutY = window?.safeAreaInsets.top ?? 0.0
        }
        let breachesRect = CGRect(x: 0,
                                  y: topLayoutY + 95.5,
                                  width: screenSize.width,
                                  height: screenSize.height - topLayoutY - 95.5)
        containerView.frame = breachesRect
        
        detailView.frame = breachesRect
        detailView.layer.position.x = self.view.frame.width * 2
        
        btnPrivacy.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyButtonTouchUpInside)))
        btnProviders.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(providersButtonTouchUpInside)))
        detailHeaderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideDetailView)))
    }
    
    @objc func privacyButtonTouchUpInside() {
        txtDetailHeader.text = "Privacy Policy"
        let url = Bundle.main.url(forResource: "privacy", withExtension: "html")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.containerView.layer.position.x = -self.view.frame.width / 2
                        self.detailView.layer.position.x = self.view.frame.width / 2
        })
    }
    
    @objc func providersButtonTouchUpInside() {
        txtDetailHeader.text = "Data Providers"
        let url = Bundle.main.url(forResource: "providers", withExtension: "html")
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
        
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.containerView.layer.position.x = -self.view.frame.width / 2
                        self.detailView.layer.position.x = self.view.frame.width / 2
        })
    }
    
    @objc func hideDetailView() {
        UIView.animate(withDuration: 0.5,
                       animations: {
                        self.containerView.layer.position.x = self.view.frame.width / 2
                        self.detailView.layer.position.x = self.view.frame.width * 2
        })
    }

    @IBAction func closeButtonTouchUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
