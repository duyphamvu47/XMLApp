//
//  DBHelper.swift
//  XMPApp
//
//  Created by Vu Duy on 10/07/2021.
//

import Foundation
import SQLite3
import UIKit

class DBHelper{
    var db : OpaquePointer?
    static let shareObject = DBHelper() // singleton
    
    private init() {
        self.db = createDB()
        self.createTable()
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(DBName)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        }else {
            print("Database has been created with path \(DBName)")
            return db
        }
    }
    
    func createTable()  {
            let query = "CREATE TABLE IF NOT EXISTS \(tableName)(id TEXT PRIMARY KEY, path TEXT);"
            var statement : OpaquePointer? = nil
            
            if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Table creation success")
                }else {
                    print("Table creation fail")
                    let alertController = UIAlertController(title: "Error", message: "Error when creating table", preferredStyle: .alert)
                    alertController.show()
                }
            } else {
                print("Prepration fail")
                let alertController = UIAlertController(title: "Error", message: "Error when creating table", preferredStyle: .alert)
                alertController.show()
            }
    }
    
    func insert(id: String, path: String)-> Bool {
        let query = "INSERT INTO \(tableName) (id, path) VALUES (?, ?);"
        
        var statement : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (path as NSString).utf8String, -1, nil)
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data inserted success")
                return true
            }else {
                print("Data is not inserted in table")
                let alertController = UIAlertController(title: "Error", message: "Error when insert to table", preferredStyle: .alert)
                alertController.show()
                return false
            }
        } else {
            print("Query is not as per requirement")
            let alertController = UIAlertController(title: "Error", message: "Error when insert to table", preferredStyle: .alert)
            alertController.show()
            return false
        }
    }
    
    func read() -> [(String, String)] {
        var res:[(String, String)] = []
        
        let query = "SELECT * FROM \(tableName);"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = String(describing: String(cString: sqlite3_column_text(statement, 0)))
                let path = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                res.append((id, path))
            }
        }
        return res
    }
}


// Extension to help display alert message to user
extension UIAlertController {
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        if let rootVC = keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if
            let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController
        {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else if
            let tabVC = controller as? UITabBarController,
            let selectedVC = tabVC.selectedViewController
        {
            presentFromController(controller: selectedVC, animated: animated, completion: completion)
        } else if let presented = controller.presentedViewController {
            presentFromController(controller: presented, animated: animated, completion: completion)
        } else {
            controller.present(self, animated: animated, completion: completion);
        }
    }
}
