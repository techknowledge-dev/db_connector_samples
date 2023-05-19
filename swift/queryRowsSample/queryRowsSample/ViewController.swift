//
//  ViewController.swift
//  queryRowsSample
//
//  Created on 2020/12/02.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, dbLibDelegate {
    @IBOutlet weak var _tableView: UITableView!
    private var _rows:NSMutableArray!
    private var _db:dbLib!
    
    //
    //  MARK: dblib code
    //
    func startConnect() {
        
        _db = dbLib.init()
        _db.delegate = self
        _db.url = "http://192.168.0.18:8000"
        _db.verbose = true
        let rc = _db.connect()
        if rc != Normal {
            print("connect failed \(rc)")
            return
        }
        
    }
    
    func requestCompleted(_ methodName: String!) {
        print("request completed:" + methodName)
        
        if methodName == "Login" {
            let qrc = _db.queryRows("select EMPNO,ENAME from emp order by empno", 100)
            print("query result= \(qrc)")
        }
        
    }
    
    func requestFailed(_ methdName: String!, _ error: Error!) {
        print("request failed \(String(describing: error))")
    }
    
    func queryRowsCompleted(_ rows: NSMutableArray!) {
        DispatchQueue.main.async {
            self._rows = rows
            self._tableView.reloadData()
            self._db.disconnect()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startConnect()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if _rows == nil {
            return 0
        }
        return _rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        let row:NSDictionary = _rows[indexPath.row] as! NSDictionary
        let empno = row.value(forKey: "EMPNO") as! String
        let ename = row.value(forKey: "ENAME") as! String
        cell.textLabel!.text = empno + " " + ename
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

