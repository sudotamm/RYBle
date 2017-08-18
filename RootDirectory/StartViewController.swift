//
//  StartViewController.swift
//  RootDirectory
//
//  Created by Ryan on 8/3/16.
//  Copyright © 2016 Ryan. All rights reserved.
//
import UIKit
import RYUtils

class StartViewController: UIViewController {
    
    @IBOutlet weak var startImageView: UIImageView!
    
    //MARK: UIViewController methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //usleep(3500000);
        NotificationCenter.default.post(name: Notification.Name(rawValue: ShowPannelViewNotification), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startImageView.image = UIImage.assetLaunch()
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}
