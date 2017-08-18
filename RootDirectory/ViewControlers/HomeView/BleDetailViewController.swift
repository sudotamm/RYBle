//
//  BleDetailViewController.swift
//  RootDirectory
//
//  Created by Ryan on 15/08/2017.
//  Copyright © 2017 Ryan. All rights reserved.
//

import UIKit
import CryptoSwift
import RYBle

class BleDetailViewController: BaseViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    func reloadBleDetail(){
        self.setNaviTitle(RYBleManager.sharedManager.connectedPeriheral?.name ?? "Peripheral")
        self.contentTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(type(of: self).reloadBleDetail), name: NSNotification.Name(BleValueUpdateNotification), object: nil)
        self.contentTableView.tableFooterView = UIView()
        
        self.reloadBleDetail()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BleDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let service = RYBleManager.sharedManager.connectedPeriheral?.services?[section]
        return service!.characteristics?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell")!
        let service = RYBleManager.sharedManager.connectedPeriheral?.services?[indexPath.section]
        let character = service!.characteristics?[indexPath.row]
        if service!.uuid.description == Service16BitUUID{
            
            var uuidDes = character!.uuid.description
            if uuidDes == "FFF1"{
                uuidDes = "BatteryLevel"
            }else if uuidDes == "FFF2"{
                uuidDes = "Temperature"
            }else if uuidDes == "FFF3"{
                uuidDes = "Humidity"
            }else if uuidDes == "FFF4"{
                uuidDes = "PM2.5"
            }else if uuidDes == "FFF5"{
                uuidDes = "HCHO"
            }
            cell.textLabel?.text = uuidDes
            
            if let value = character?.value{
                let hexString = value.toHexString()
                let u16intValue = UInt16(hexString, radix: 16) ?? 0
                
                var swapu16intValue = u16intValue
                if hexString.characters.count == 4{
                    swapu16intValue = CFSwapInt16BigToHost(u16intValue)
                }
                cell.detailTextLabel?.text = String(swapu16intValue)
            }else{
                cell.detailTextLabel?.text = ""
            }
        }else{
            cell.textLabel?.text = character!.uuid.description
            if let value = character?.value{
                cell.detailTextLabel?.text = String(data: value, encoding: .utf8) ?? ""
            }else{
                cell.detailTextLabel?.text = ""
            }
            
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return RYBleManager.sharedManager.connectedPeriheral?.services?.count ?? 0
    }
    

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        let service = RYBleManager.sharedManager.connectedPeriheral?.services?[section]
        return service!.uuid.description
    }
}
