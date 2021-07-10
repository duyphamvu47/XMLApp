//
//  ViewController.swift
//  XMPApp
//
//  Created by Vu Duy on 09/07/2021.
//

import UIKit
import UniformTypeIdentifiers
import MobileCoreServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate {
    @IBOutlet var tableView: UITableView!
    var isDefaultFolderCreated: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.checkDefaultFolder()
        // Do any additional setup after loading the view.
    }
    
    func createDefaultFolder(){
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destURL = dir.appendingPathComponent("official-data")
        do{
            try FileManager.default.createDirectory(atPath: destURL.path, withIntermediateDirectories: true, attributes: nil)
        }
        catch{
            print("Error: \(error)")
        }
    }
    
    func checkDefaultFolder(){
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
    //Table func
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "None"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    @IBAction func addBtnClicked(){
//        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        let types = UTType.types(tag: "xml",
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil)
        let documentPickerController = UIDocumentPickerViewController(
                forOpeningContentTypes: types)
        documentPickerController.delegate = self
        self.present(documentPickerController, animated: true, completion: nil)
    }
    
    
    func copyFile(srcURL: URL)-> String {
        let fileName = srcURL.lastPathComponent
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destURL = dir.appendingPathComponent("official-data").appendingPathComponent(fileName)
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
    
}

extension ViewController: UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        let parser = HNXMLParser()
        let res = parser.startParsingFileFromURL(url: myURL)
        if res != ""{
            let newURL = copyFile(srcURL: myURL)
            print(parser.startParsingFileFromURL(url: URL(fileURLWithPath: newURL)))
            
        }

    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
}

