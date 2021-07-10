//
//  ViewController.swift
//  XMPApp
//
//  Created by Vu Duy on 09/07/2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
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
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)

        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
}

extension ViewController: UIDocumentPickerDelegate{


   func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {

             let cico = url as URL
             print(cico)
             print(url)

             print(url.lastPathComponent)

             print(url.pathExtension)

            }
}

