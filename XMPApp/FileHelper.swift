//
//  FileHelper.swift
//  XMPApp
//
//  Created by Vu Duy on 10/07/2021.
//

import Foundation

class FileHelper{
    static func createDefaultFolder(){
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destURL = dir.appendingPathComponent("official-data")
        do{
            try FileManager.default.createDirectory(atPath: destURL.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch{
            print("Error: \(error)")
        }
    }
    
    static func checkDefaultFolder(){
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destURL = dir.appendingPathComponent("official-data")
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: destURL.path, isDirectory:&isDir) {
            if isDir.boolValue {
                // file exists and is a directory
                isDefaultFolderCreated = true
                print(isDir.boolValue)
            } else {
                // file exists and is not a directory
                createDefaultFolder()
            }
        } else {
            // file does not exist
            createDefaultFolder()
        }
    }
    
    static func copyFile(srcURL: URL)-> String {
        let fileName = srcURL.lastPathComponent
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destURL = dir.appendingPathComponent(defaultFolderName).appendingPathComponent(fileName)
        var res:String = ""
        do {
            try FileManager.default.copyItem(atPath: srcURL.path, toPath: destURL.path)
            res = destURL.path
        }
        catch {
            print("Error: \(error)")
            
        }
        return res

    }
    
    static func getSaveDir(fileName: String)-> URL{
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destURL = dir.appendingPathComponent(defaultFolderName).appendingPathComponent(fileName)
        return destURL
    }
}
