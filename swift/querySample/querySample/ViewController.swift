//
//  ViewController.swift
//  querySample
//
//  Created on 2020/12/05.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, dbLibDelegate {
    @IBOutlet weak var _tableView: UITableView!
    private var _rows:NSMutableArray = NSMutableArray.init()
    private var _db:dbLib!
    
    //
    //  MARK: dbLib codes
    //
    func startConnect() {
        _db = dbLib.init()
        _db.url = "http://192.168.0.18:8000"    // <== change here.
        // _db.url = "http://192.168.179.8/"    // <== change here.
        _db.verbose = true
        _db.delegate = self
        
        let rc = _db.connect()
        
        if(rc != Normal) {
            print("connect failed \(rc)")
            return;
        }
    }
    
    func startQuery() {
        let rc = _db.query("select EMPNO,ENAME from EMP order by EMPNO")
        if rc != Normal {
            print("query request failed \(rc)");
        }
    }
    
    func rowFetched(_ row: NSMutableDictionary!) -> Bool {
        let empno:String = row.value(forKey: "EMPNO") as! String
        let ename:String = row.value(forKey: "ENAME") as! String
        let line = empno + " " + ename
        _rows.add(line)
        return true
    }
    
    func requestCompleted(_ methodName: String!) {
        
        print("request completed \(String(describing: methodName))")
        if methodName == "Login" {
            self.startQuery()
        }
        
    }
    
    func requestFailed(_ methodName: String!, _ error: Error!) {
        print("request failed \(String(describing: methodName)) \(String(describing: error))")
    }
    
    func queryCompleted() {
        DispatchQueue.main.async {
            print("queryCompleted")
            self._tableView.reloadData()
        }
    }
    
    //
    //  MARK: view interactions
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startConnect()
    }
    
    //
    //  MARK: table view
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let line = _rows[indexPath.row] as! String
        cell.textLabel!.text = line
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

