//
//  RYBleManager.swift
//  RYBleDemo
//
//  Created by Ryan on 11/08/2017.
//  Copyright © 2017 Ryan. All rights reserved.
//

import Foundation
import CoreBluetooth

/// 自定义的Ble state管理枚举，涵盖了蓝牙启动、扫描、连接及数据更新过程中的错误状态
public enum RYBleState: Error, CustomStringConvertible{

    case unknown
    case resetting
    case unsupported
    case unauthorized
    case poweredOff
    case poweredOn
    
    case connectFailed
    case discoverServiceFailed
    case discoverCharacterFailed
    case updateStateFailed
    case updateValueFailed
    case disconnected
    
    public var description: String{
        switch self {
        case .poweredOn: return "Bluetooth is open"
        case .poweredOff: return "Bluetooth not open"
        case .unsupported: return "Bluetooth sdk not support"
        case .unauthorized: return "Bluetooth not authed"
        case .resetting: return "CBCentralManagerStateResetting"
        case .unknown: return "CBCentralManagerStateUnknown"
        case .connectFailed: return "ble: did fail to connect peripheral"
        case .discoverServiceFailed: return "ble: did discover services error"
        case .discoverCharacterFailed: return "ble: did discover character error"
        case .updateStateFailed: return "ble: did update notification state error"
        case .updateValueFailed: return "ble: did update value error"
        case .disconnected: return "ble: did disconnect peripheral"
        }
    }
}

/// 基于CoreBluetooth库封装的BleCentral服务类，使用block的方式简化了蓝牙启动，扫描及配对的回调流程
public class RYBleManager: NSObject{
    
    public static let sharedManager = RYBleManager()
    
    public var discoverys = [[String: AnyObject]]()
    public var connectedPeriheral: CBPeripheral?
    
    fileprivate var cbManager: CBCentralManager!
    //初始化回调
    fileprivate var initCompletion: ((RYBleState)->Void)?
    fileprivate var initError: ((RYBleState)->Void)?
    //扫描回调
    fileprivate var scanCallback: (([[String: AnyObject]])->Void)?
    fileprivate var scanCompletion: (()->Void)?
    fileprivate var scanError: ((RYBleState)->Void)?
    //连接回调
    fileprivate var connectedBlock: (()->Void)?
    fileprivate var connectdUpdateBlock: ((CBCharacteristic)->Void)?
    fileprivate var connectdErrorBlock: ((RYBleState)->Void)?
    
    private override init(){
        super.init()
    }
    
    //MARK: Public methods
    /// 检查Central设备的蓝牙状态
    ///
    /// - returns                   :RYBleState
    public func checkBleStatus() -> RYBleState{
        switch self.cbManager.state {
        case .poweredOff: return .poweredOff
        case .poweredOn: return .poweredOn
        case .resetting: return .resetting
        case .unauthorized: return .unauthorized
        case .unknown: return .unknown
        case .unsupported: return .unsupported
        }
    }
    
    /// 停止设备扫描
    public func stopScan(){
        self.cbManager.stopScan()
        self.scanCompletion?()
    }
    
    /// 初始化Central蓝牙状态
    ///
    /// - parameter completion      :蓝牙成功打开状态回调
    /// - parameter error           :蓝牙启动失败状态回调
    public func bleInit(completion: ((RYBleState)->Void)?, error: ((RYBleState)->Void)?){
        self.initCompletion = completion
        self.initError = error
        print("ble: init central manager.")
        self.cbManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
    }
    
    /// 扫描附件蓝牙配件
    ///
    /// - parameter services        :设备开启的服务列表, nullable
    /// - parameter discoverBlock   :发现设备后的回调
    /// - parameter completionBlock :扫描完成后的回调
    /// - parameter errorBlock      :扫描失败的回调
    public func scan(services: [CBUUID]?,discoverBlock: @escaping ([[String: AnyObject]])->Void, completionBlock: @escaping ()->Void, errorBlock: @escaping (RYBleState)->Void){
        self.scanCallback = discoverBlock
        self.scanCompletion = completionBlock
        self.scanError = errorBlock
        guard self.checkBleStatus() == .poweredOn else {
            self.scanError?(self.checkBleStatus())
            return
        }
        self.cbManager.scanForPeripherals(withServices: services, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
    }

    /// 连接指定的蓝牙配件
    ///
    /// - parameter peripheral       :需要连接的设备
    /// - parameter connected        :连接成功后的回调
    /// - parameter updateValue      :设备数据更新后的回调
    /// - parameter errorBlock       :连接失败的回调
    public func connect(peripheral: CBPeripheral, connected: @escaping ()->Void, updateValue: @escaping (CBCharacteristic)->Void, errorBlock:@escaping (RYBleState)->Void){
        print("ble: start connect peripheral.")
        peripheral.delegate = self
        self.connectedBlock = connected
        self.connectdUpdateBlock = updateValue
        self.connectdErrorBlock = errorBlock
        guard self.checkBleStatus() == .poweredOn else {
            self.connectdErrorBlock?(self.checkBleStatus())
            return
        }
        self.cbManager.connect(peripheral, options: [CBConnectPeripheralOptionNotifyOnDisconnectionKey: true])
        self.stopScan()
    }
}

//MARK: CBCentralManagerDelegate methods
extension RYBleManager: CBCentralManagerDelegate{
    
    public func centralManagerDidUpdateState(_ central: CBCentralManager){
        switch central.state {
        case .poweredOn:
            print("ble: bluetooth is ok.")
            self.initCompletion?(.poweredOn)
        case .poweredOff: self.initError?(.poweredOff)
        case .unsupported: self.initError?(.unsupported)
        case .unauthorized: self.initError?(.unauthorized)
        case .resetting: self.initError?(.resetting)
        case .unknown: self.initError?(.unknown)
        }
    }
    
    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
        print("ble: discover name: \(peripheral.name ?? ""), identifier: \(peripheral.identifier), advertise data: \(advertisementData), rssi: \(RSSI)")
        if self.discoverys.count == 0{
            self.discoverys.append(["peripheral": peripheral, "rssi": RSSI])
        }else{
            var exist = false
            for (index, dict) in self.discoverys.enumerated(){
                let per = dict["peripheral"] as! CBPeripheral
                if per.identifier.uuidString == peripheral.identifier.uuidString{
                    exist = true
                    let newDict = ["peripheral": peripheral, "rssi": RSSI]
                    self.discoverys[index] = newDict
                }
            }
            if !exist{
                self.discoverys.append(["peripheral": peripheral, "rssi": RSSI])
            }
        }
        self.scanCallback?(self.discoverys)
    }
    
    
    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        print("ble: did connect peripheral.")
        self.connectedPeriheral = peripheral
        self.connectedBlock?()
        peripheral.discoverServices(nil)
    }
    
    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?){
        print("ble: did fail to connect peripheral - \(String(describing: error))")
        self.connectedPeriheral = nil
        self.connectdErrorBlock?(.connectFailed)
    }
    

    public func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?){
        print("ble: did disconnect peripheral - \(String(describing: error))")
        self.connectedPeriheral = nil
        self.connectdErrorBlock?(.disconnected)
    }
}

//MARK: CBPeripheralDelegate methods
extension RYBleManager: CBPeripheralDelegate{
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?){
        if let e = error{
            print("ble: did discover services error - \(e)")
            self.connectdErrorBlock?(.discoverServiceFailed)
            return
        }
        if let services = peripheral.services{
            for service in services{
                print("ble: discover services: \(service.uuid)")
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?){
        if let e = error{
            print("ble: did discover character error - \(e)")
            self.connectdErrorBlock?(.discoverCharacterFailed)
            return
        }
        
        if let characters = service.characteristics{
            for character in characters{
                let property = character.properties
                if property == .broadcast{
                    //如果是广播特性
                }
                if property == .read{
                    //如果具备读特性，可以读取特性的value
                    peripheral.readValue(for: character)
                }
                if property == .writeWithoutResponse{
                    //如果具备写入值不需要想要的特性
                    //这里保存这个可以写的特性，便于后面往这个特性中写数据
                    
                }
                if property == .write{
                    //如果具备写入值的特性，这个应该会有一些响应
                }
                if property == .notify{
                    //如果具备通知的特性，无响应
                    peripheral.setNotifyValue(true, for: character)
                }
            
            }
        }
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?){
        if let e = error{
            print("ble: did update notification state error - \(e)")
            self.connectdErrorBlock?(.updateStateFailed)
            return
        }
        let property = characteristic.properties
        if property == .read{
            //如果具备读特性，即可以读取特性的value
            peripheral.readValue(for: characteristic)
        }
    
    }
    
    public func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?){
        if let e = error{
            print("ble: did update value error - \(e)")
            self.connectdErrorBlock?(.updateValueFailed)
            return
        }
        
        if let data = characteristic.value{
            
            let str = String(data: data, encoding: .utf8) ?? ""
            
            print("ble: did update value: service=\(characteristic.service.uuid), character=\(characteristic.uuid), value=\(str)")
            self.connectdUpdateBlock?(characteristic)
        }
    }
}
