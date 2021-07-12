//
//  ViewController.swift
//  XMPApp
//
//  Created by Vu Duy on 09/07/2021.
//

import UIKit
import UniformTypeIdentifiers
import MobileCoreServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    var data:[(id: String, url: String)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        FileHelper.checkDefaultFolder()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        data = DBHelper.shareObject.read()
        tableView.reloadData()
    }
    //Table func
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let fileName = URL(fileURLWithPath: data[indexPath.row].url).lastPathComponent
        cell.textLabel?.text = "File: \(fileName)"
        cell.detailTextLabel?.text = "intanceID: \(data[indexPath.row].id)"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
    @IBAction func addBtnClicked(){
        let types = UTType.types(tag: "xml",
                                 tagClass: UTTagClass.filenameExtension,
                                 conformingTo: nil)
        let documentPickerController = UIDocumentPickerViewController(
                forOpeningContentTypes: types)
        documentPickerController.delegate = self
        documentPickerController.allowsMultipleSelection = true
        self.present(documentPickerController, animated: true, completion: nil)
    }
    func loadData(){
        data = DBHelper.shareObject.read()
    }
    
    
    
}

extension ViewController: UIDocumentPickerDelegate{
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let viewController = storyboard?.instantiateViewController(identifier: "progressView") as? ProgressController else{
            return
        }
        viewController.navigationItem.largeTitleDisplayMode = .never
        viewController.data = urls
            
        self.navigationController?.pushViewController(viewController, animated: true)

    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
    
}

