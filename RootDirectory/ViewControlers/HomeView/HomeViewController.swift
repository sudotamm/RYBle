//
//  HomeViewController.swift
//  RootDirectory
//
//  Created by Ryan on 8/3/16.
//  Copyright © 2016 Ryan. All rights reserved.
//

import UIKit
import CoreBluetooth
import SVProgressHUD
import RYBle

let Service16BitUUID = "FFF0"
let Service128BitUUID = "0000FFF0-0000-1000-8000-00805F9B34FB"  //0000xxxx-0000-1000-8000-00805F9B34FB
let Character128BitUUID = "0000FFF1-0000-1000-8000-00805F9B34FB"
let BleValueUpdateNotification = "BleValueUpdateNotification"

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    var refreshControl: UIRefreshControl = {
        var rc = UIRefreshControl()
        rc.tintColor = MainProjColor
        rc.attributedTitle = NSAttributedString(string: "Bluetooth Searching...")
        return rc
    }()
    
    @IBOutlet var footerView: UIView!
    @IBOutlet weak var footerLabel: UILabel!
    
    
    var bleArray = [[String: AnyObject]]()
    
    //MARK: Private methods
    
    @objc func refreshTrigger(rc: UIRefreshControl){
        if rc.isRefreshing{
            
            let services: [CBUUID]? = nil//[CBUUID(string: Service128BitUUID)]
            RYBleManager.sharedManager.scan(services: services, discoverBlock: { discoverys in
                self.refreshControl.endRefreshing()
                self.bleArray = discoverys
                self.reloadDetail()
            }, completionBlock: {
                self.refreshControl.endRefreshing()
            }, errorBlock: { state in
                self.refreshControl.endRefreshing()
                SVProgressHUD.showError(withStatus: state.description)
                
                self.bleArray.removeAll()
                self.reloadDetail()
            })
        }
    }
    
    func reloadDetail(){
        self.contentTableView.reloadData()
        if self.bleArray.count == 0{
            self.contentTableView.tableFooterView = self.footerView
            self.footerLabel.text = ConstantString.HomePage.noBleFound.rawValue
        }else{
            self.contentTableView.tableFooterView = UIView()
        }
    }

    //MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNaviTitle("RYBleCentral")
        self.contentTableView.tableFooterView = UIView()
        self.contentTableView.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(type(of: self).refreshTrigger(rc:)), for: .valueChanged)
        self.refreshControl.beginRefreshing()
        self.refreshTrigger(rc: self.refreshControl)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.bleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BleCell")!
        
        let discovery = self.bleArray[indexPath.row]
        let peripheral = discovery["peripheral"] as! CBPeripheral
        let rssi = discovery["rssi"] as! NSNumber
        cell.textLabel?.text = peripheral.name ?? "Unknown"
        cell.detailTextLabel?.text = String(describing: rssi)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        
        let discovery = self.bleArray[indexPath.row]
        let peripheral = discovery["peripheral"] as! CBPeripheral
        SVProgressHUD.show(withStatus: "Connecting...")
        SVProgressHUD.setDefaultMaskType(.black)
        RYBleManager.sharedManager.connect(peripheral: peripheral, connected: {
            self.performSegue(withIdentifier: "BleListToDetail", sender: nil)
            SVProgressHUD.setDefaultMaskType(.none)
            SVProgressHUD.dismiss()
        }, updateValue: { _ in
            NotificationCenter.default.post(name: Notification.Name(BleValueUpdateNotification), object: nil)
        }) { bleError in
            NotificationCenter.default.post(name: Notification.Name(BleValueUpdateNotification), object: nil)
            SVProgressHUD.showError(withStatus: bleError.description)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
