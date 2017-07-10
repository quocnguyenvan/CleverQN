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
    
    
    var stop: UIBarButtonItem! = nil

    var centralManager: CBCentralManager?
    var discoveredPeripheral: CBPeripheral?
    
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
        print("state: \(central.state)")
        if (central.state == .poweredOn) {
            startScan()
        } else {
            print("Chưa bật bluetooth!")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered peripheral: \(peripheral)")
        
        if discoveredPeripheral != peripheral {
            // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
            discoveredPeripheral = peripheral
            
            // And connect
            print("Connecting to peripheral \(peripheral)")
            
            centralManager?.connect(peripheral, options: nil)
        }
    }
    
    // Called when it succeeded
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral connected!")
        // Stop scanning
        centralManager?.stopScan()
        print("Scanning stopped")
        
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
    
    func startScan() {
        centralManager?.scanForPeripherals(
            withServices: nil, options: [
                CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)
            ]
        )
        centralManager?.scanForPeripherals(withServices: nil, options: nil)
        print("Scanning started")
    }
    
    func stopScan() {
        centralManager?.stopScan()
    }
    
    func refresh() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
            
            if (self.refreshControl.isRefreshing) {
                let count = self.nameArr.count
                let nextCount = count + 1
                self.nameArr.append("Clever-00" + String(nextCount))
                self.iPArr.append("60:00:00:00:00:24")
                self.refreshControl.endRefreshing()
            }
            self.tblSelectLock.reloadData()
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
//        let splash = Bundle.main.loadNibNamed("SplashScreen", owner: self, options: nil)?.first as! SplashScreenController
//        present(splash, animated: true, completion: nil)
    }
    
    func startTap() {
        self.navigationItem.setRightBarButtonItems([stop], animated: true)
//        tblSelectLock.isHidden = true
        self.refreshControl.beginRefreshing()
        self.refresh()
    }
    
    func stopTap() {
        if (self.refreshControl.isRefreshing) {
            self.refreshControl.endRefreshing()
        }
        clearClockTable()
        let start = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(ViewController.startTap))
        self.navigationItem.setRightBarButtonItems([start], animated: true)
    }
    
    func clearClockTable() {
        self.nameArr.removeAll()
        self.iPArr.removeAll()
        self.tblSelectLock.reloadData()
    }
}

extension ViewController: UITableViewDataSource, CellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SelectLockCell
        
        cell.lblName.text = nameArr[indexPath.row]
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
        let mainView = storyboard?.instantiateViewController(withIdentifier: "MainView")
        
        navigationController?.pushViewController(mainView!, animated: true)
        print(nameArr[row])
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? { return nil }
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset < -150 {
            print("offset")
        }
    }
}
