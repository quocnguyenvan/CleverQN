//
//  ViewController.swift
//  CleverApp
//
//  Created by Quoc Nguyen on 6/5/17.
//  Copyright © 2017 Rynan. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {

    let refreshControl = UIRefreshControl()
    var nameArr: [String] = ["Clever-001", "Clever-002", "Clever-003"]
    var iPArr: [String] = []
    var tapInfo: Bool = false
    var tapStop: Bool = false
    var isOpenBluetooth = false
    var bluetoothState: String = ""
    
    var stop: UIBarButtonItem! = nil

    var centralManager: CBCentralManager?
    var discoveredPeripheral: [CBPeripheral] = []
    
    let DEVICE_NAME = "name"
    let DEVICE_SERVICE_UUID = "181C"
    let DEVICE_CHARACTERISTIC_UUID = "2A99"
    let RESTORE_IDENTIFIER = "restoreKeyForDevice"
    let vc = UserScreenController()
    
    fileprivate let data = NSMutableData()
    
    @IBOutlet weak var tblSelectLock: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblSelectLock.dataSource = self
        tblSelectLock.delegate = self
        // khoá row không cho chọn
        tblSelectLock.allowsSelection = false
        // pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.addTarget(self, action: #selector(ViewController.refresh), for: UIControlEvents.valueChanged)
        if #available(iOS 10.0, *) {
            tblSelectLock.refreshControl = refreshControl
        } else {
            tblSelectLock.addSubview(refreshControl)
        }
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil) // options: [CBCentralManagerOptionRestoreIdentifierKey:RESTORE_IDENTIFIER]
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        switch central.state {
        case .poweredOn:
            isOpenBluetooth = true
            startScan()
            bluetoothState = "Bluetooth on this device is currently powered on."
            break
        case .poweredOff:
            isOpenBluetooth = false
            discoveredPeripheral.removeAll()
            iPArr.removeAll()
            tblSelectLock.reloadData()
            bluetoothState = "Bluetooth on this device is currently powered off."
            vc.showMessage(content: "Bluetooth on this device is currently powered off", theme: .warning, duration: 2.0)
            break
        case .unsupported:
            isOpenBluetooth = false
            bluetoothState = "This device does not support Bluetooth Low Energy."
            vc.showMessage(content: "This device does not support Bluetooth Low Energy", theme: .warning, duration: 2.0)
            break
        case .unauthorized:
            isOpenBluetooth = false
            bluetoothState = "This app is not authorized to use Bluetooth Low Energy."
            vc.showMessage(content: "This app is not authorized to use Bluetooth Low Energy", theme: .warning, duration: 2.0)
            break
        case .resetting:
            isOpenBluetooth = false
            bluetoothState = "The BLE Manager is resetting; a state update is pending."
            vc.showMessage(content: "The BLE Manager is resetting; a state update is pending", theme: .info, duration: 2.0)
            break
        case .unknown:
            isOpenBluetooth = false
            bluetoothState = "The state of the BLE Manager is unknown."
            vc.showMessage(content: "The state of the BLE Manager is unknown", theme: .warning, duration: 2.0)
            break
        }
        print(bluetoothState)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral) at \(RSSI)")
        if !discoveredPeripheral.contains(peripheral) {
            
            // 50:00:00:00:00:06 // 2 5 8 11 14
            if let UUIDAdvertis = advertisementData["kCBAdvDataServiceUUIDs"] as? NSArray {
                var addressString: String = ""
                for item in UUIDAdvertis {
                    let stringUUID = item as! CBUUID
                    addressString += stringUUID.uuidString
                }
                print("Address: \(addressString)")
                var offset = 0
                for i in 0..<(addressString.characters.count/2) - 1 {
                    offset += 2
                    addressString.insert(contentsOf: ":".characters, at: addressString.index(addressString.startIndex, offsetBy: i+offset))
                }
                print(addressString)
                discoveredPeripheral.append(peripheral)
                iPArr.append(addressString)
            }
            tblSelectLock.reloadData()
        }
        
//        if let peripheralName = peripheral.name, peripheralName == DEVICE_NAME {
//            central.stopScan()
//            self.device = peripheral
//            self.device.delegate = self
//            central.connect(peripheral, options: nil)
//        }
    }
    
    // Called when it succeeded, get services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to device: \(String(describing: peripheral.name))")
        vc.showMessage(content: "Connected to device: \(String(describing: peripheral.name))", theme: .success, duration: 3.0)
        peripheral.discoverServices(nil)
        peripheral.delegate = self
        
        stopScan()
        
        // Search only for services that match our UUID
//        peripheral.discoverServices([transferServiceUUID])
    }
    
    // Called when it failed
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral). (\(error!.localizedDescription))")
//        cleanup()
    }
    
    // get characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if service.uuid.uuidString == DEVICE_SERVICE_UUID {
                peripheral.discoverCharacteristics(nil, for: thisService) // [transferCharacteristicUUID]
                print("thisService: \(thisService)")
            }
        }
    }
    
    // Subscribing to characteristic's value changes
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            
            if thisCharacteristic.uuid.uuidString == DEVICE_CHARACTERISTIC_UUID {
                // If it is, subscribe to it
                peripheral.setNotifyValue(true, for: thisCharacteristic)
                
                peripheral.readValue(for: thisCharacteristic)
                
                print("thisCharacteristic: \(thisCharacteristic)")
            }
        }
    }
    
    // Receiving updates
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        if characteristic.uuid.uuidString == DEVICE_CHARACTERISTIC_UUID {
            if let data = characteristic.value { // let stringData: String = String(data: data, encoding: .utf8)
                
                var arr_FirstData : [UInt8] = [UInt8]()
            
                arr_FirstData = [UInt8](repeating: 0, count: data.count)
                data.copyBytes(to: &arr_FirstData, count: data.count)
                
                print("Data: \(data)")
                let stringData: String = String(data: data, encoding: String.Encoding.utf8)!
                print("stringData: \(stringData)")
                
            } else {
                print("Invalid data")
            }
        }
        
        // Have we got everything we need?
//        if stringFromData.isEqual(to: "EOM") {
            // We have, so show the data
//            print("\(String(describing: String(data: data.copy() as! Data, encoding: String.Encoding.utf8)))")
        
            // Cancel our subscription to the characteristic
//            peripheral.setNotifyValue(false, for: characteristic)
        
            // and disconnect from the peripehral
//            centralManager?.cancelPeripheralConnection(peripheral)
//        } else {
            // Otherwise, just add the data on to what we already have
//            data.append(characteristic.value!)
        
            // Log it
//            print("Received: \(stringFromData)")
//        }
    }
    
    // Restore state
//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
//        if let peripherals : NSArray = dict[CBCentralManagerOptionRestoreIdentifierKey] as? NSArray {
//            for peripheral in peripherals {
//                if let peripheralName = peripheral.name, peripheralName == DEVICE_NAME {
//                    central.stopScan()
//                    centralManager = central
//                    self.device = peripheral
//                    self.device.delegate = self
//                    central.connect(peripheral as! CBPeripheral, options: nil)
//                }
//            }
//        }
//    }
    
    // Disconnect and Try Again
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Đang scan lại...")
//        startScan()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.isNotifying {
            // notification started
            print("Notification STARTED on characteristic: \(characteristic)")
        } else {
            print("Notification STOPPED on characteristic: \(characteristic)")
//            self.centralManager?.cancelPeripheralConnection(peripheral)
        }
    }
    
    func startScan() {
        discoveredPeripheral.removeAll()
        iPArr.removeAll()
        if isOpenBluetooth {
//            centralManager?.scanForPeripherals(
//                withServices: nil, options: [
//                    CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)
//                ]
//            )
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
            print("Scanning...")
        }
    }
    
    func stopScan() {
        if (self.refreshControl.isRefreshing) {
            self.refreshControl.endRefreshing()
        }
        centralManager?.stopScan()
//        tblSelectLock.reloadData()
        print("Scanning stopped!")
    }
    
    func refresh() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
//            if (self.refreshControl.isRefreshing) {
//                let count = self.nameArr.count
//                let nextCount = count + 1
//                self.nameArr.append("Clever-00" + String(nextCount))
//                self.iPArr.append("60:00:00:00:00:24")
//                self.refreshControl.endRefreshing()
//            }
//            self.tblSelectLock.reloadData()
//        }
        startScan()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.stopScan()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "ic_info"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(ViewController.infoTap), for: .touchUpInside)
        let info = UIBarButtonItem(customView: button)
        self.navigationItem.setLeftBarButtonItems([info], animated: true)
        stop = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(ViewController.stopTap))
        self.navigationItem.setRightBarButtonItems([stop], animated: true)
        // show navigationBar
        self.navigationController?.isNavigationBarHidden = false
    }
 
    func infoTap() {
        tapInfo = !tapInfo
        tblSelectLock.reloadData()
//        let mainView = storyboard?.instantiateViewController(withIdentifier: "MainView")
//        navigationController?.pushViewController(mainView!, animated: true)
    }
    
    func startTap() {
        self.navigationItem.setRightBarButtonItems([stop], animated: true)
        startScan()
    }
    
    func stopTap() {
        stopScan()
        let start = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(ViewController.startTap))
        self.navigationItem.setRightBarButtonItems([start], animated: true)
        
//        clearClockTable()
    }
    
    func clearClockTable() {
        self.nameArr.removeAll()
        self.iPArr.removeAll()
        self.tblSelectLock.reloadData()
    }
}

extension ViewController: UITableViewDataSource, CellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveredPeripheral.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectLockCell
        
        if let name = discoveredPeripheral[indexPath.row].name {
            cell.lblName.text = name
        } else {
            cell.lblName.text = "No name"
        }
        
        cell.lblIP.text = iPArr[indexPath.row]
        
        (tapInfo == true) ? (cell.lblIP.isHidden = false) : (cell.lblIP.isHidden = true)
        // bắt sự kiện nhấn nút connect trên mỗi row
        if cell.btnConnectDelegate == nil {
            cell.btnConnectDelegate = self
        }
        return cell
    }
    // kế thừa lại hàm của protocol
    func connectPressed(cell: SelectLockCell) {
        let row = tblSelectLock.indexPath(for: cell)!.row
//        let mainView = storyboard?.instantiateViewController(withIdentifier: "MainView")
//        navigationController?.pushViewController(mainView!, animated: true)
        // And connect
        print("Connecting to peripheral \(discoveredPeripheral[row])")
        centralManager?.connect(discoveredPeripheral[row], options: nil)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? { return nil }
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset < -150 {
//            print("offset")
        }
    }
}
