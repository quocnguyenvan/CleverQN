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
    var iPArr: [String] = ["50:00:00:00:00:00", "50:00:00:00:00:06", "60:00:00:00:00:07", "50:00:00:00:00:09", "50:00:00:00:00:12", "60:00:00:00:00:12"]
    var tapInfo: Bool = false
    var tapStop: Bool = false
    var isOpenBluetooth = false
    var bluetoothState: String = ""
    
    var stop: UIBarButtonItem! = nil

    var centralManager: CBCentralManager?
    var discoveredPeripheral: [CBPeripheral] = []
    
    let BEAN_NAME = "Robu"
    let BEAN_SCRATCH_UUID = CBUUID(string: "a495ff21-c5b1-4b44-b512-1370f02d74de")
    let BEAN_SERVICE_UUID = CBUUID(string: "a495ff20-c5b1-4b44-b512-1370f02d74de")
    
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
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let vc = UserScreenController()
        
        switch central.state {
        case .poweredOn:
            isOpenBluetooth = true
            startScan()
            bluetoothState = "Bluetooth on this device is currently powered on."
            break
        case .poweredOff:
            isOpenBluetooth = false
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
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            discoveredPeripheral.append(peripheral)
            tblSelectLock.reloadData()
        }
    }
    
    // Called when it succeeded, get services
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral connected!")
        peripheral.discoverServices(nil)
        stopScan()
        
        // Clear the data that we may already have
        data.length = 0
        
        // Make sure we get the discovery callbacks
        peripheral.delegate = self
        
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
            
            if service.uuid == BEAN_SERVICE_UUID {
                peripheral.discoverCharacteristics(nil, for: thisService) // [transferCharacteristicUUID]
            }
        }
    }
    
    // Setup notifications
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics! {
            let thisCharacteristic = characteristic as CBCharacteristic
            
            if thisCharacteristic.uuid == BEAN_SCRATCH_UUID {
                // If it is, subscribe to it
                peripheral.setNotifyValue(true, for: thisCharacteristic)
//                peripheral.readValue(for: thisCharacteristic)
            }
        }
    }
    
    // Changes Are Coming
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: \(error!.localizedDescription)")
            return
        }
        
        guard let stringFromData = NSString(data: characteristic.value!, encoding: String.Encoding.utf8.rawValue) else {
            print("Invalid data")
            return
        }
        
        // Have we got everything we need?
        if stringFromData.isEqual(to: "EOM") {
            // We have, so show the data
            print("\(String(describing: String(data: data.copy() as! Data, encoding: String.Encoding.utf8)))")
            
            // Cancel our subscription to the characteristic
            peripheral.setNotifyValue(false, for: characteristic)
            
            // and disconnect from the peripehral
            centralManager?.cancelPeripheralConnection(peripheral)
        } else {
            // Otherwise, just add the data on to what we already have
            data.append(characteristic.value!)
            
            // Log it
            print("Received: \(stringFromData)")
        }
        
//        if characteristic.uuid == BEAN_SCRATCH_UUID {
//        }
    }
    
    // Disconnect and Try Again
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        startScan()
    }
    
    func startScan() {
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
            self.refresh()
        }
        centralManager?.stopScan()
//        tblSelectLock.reloadData()
        print("Scanning stopped!!")
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
        button.addTarget(self, action: #selector(ViewController.infoTap), for: .editingDidEndOnExit)
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
    }
    
    func startTap() {
        self.navigationItem.setRightBarButtonItems([stop], animated: true)
//        tblSelectLock.isHidden = true
//        self.refreshControl.beginRefreshing()
//        self.refresh()
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
        
//        cell.lblIP.text = iPArr[indexPath.row]
        
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
