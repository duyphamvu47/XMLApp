//
//  ProgressController.swift
//  XMPApp
//
//  Created by Vu Duy on 10/07/2021.
//

import UIKit

enum ProcessState {
  case parse, copy, insert, cancel
}

class ProgressController: UIViewController {
    @IBOutlet var progressBar:UIProgressView!
    @IBOutlet var progressBox:UITextView!
    
    var totalTask:Float = Float(0)
    var currentProgress:Float = Float(0)
    var data:[URL] = []
    var DataState:[(state: ProcessState, url: URL, instanceID: String)] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        innitDataState()
        totalTask = Float(data.count*3)
        progressBar.progressTintColor = .systemBlue
        progressBar.trackTintColor = .gray
        progressBar.setProgress(0.0, animated: false)
        

    }
    override func viewDidAppear(_ animated: Bool) {
        for (index, _) in DataState.enumerated(){
            TaskControl(index: index)
            print(DataState[index].url)
        }
    }
    
    func innitDataState(){
        for myURL in data{
            DataState.append((.parse, myURL, ""))
        }
    }
    
    func TaskControl(index: Int){
        while self.DataState[index].state != .cancel{
            switch self.DataState[index].state {
            case .parse:
                parseTask(index: index)
                
            case .copy:
                copyTask(index: index)
        
            case .insert:
                insertTask(index: index)
            case .cancel:
                break
            }
        }
    }
    
    
    func parseTask(index: Int){
        //Parse XML
        DispatchQueue.global(qos: .userInteractive).sync {
            let myURL = self.DataState[index].url
            let parser = HNXMLParser()
            var message:String = ""
            let res = parser.startParsingFileFromURL(url: myURL)
            // Can't read instanceID
            if res.isEmpty{
                self.currentProgress += 3
                message = "Parse " +  myURL.lastPathComponent + " fail\n"
                self.DataState[index].state = .cancel
            }
            else{
                self.currentProgress += 1
                message = "Parse " +  myURL.lastPathComponent + " success\n"
                self.DataState[index].state = .copy
                self.DataState[index].instanceID = res
            }
            //Update progress
            DispatchQueue.main.async {
                self.progressBar.setProgress(self.currentProgress/self.totalTask, animated: true)
                self.progressBox.text += message
            }
        }
    }
    
    func copyTask(index: Int){
        DispatchQueue.global(qos: .userInteractive).sync {
            let myURL = DataState[index].url
            var message:String = ""
            let newURL = FileHelper.copyFile(srcURL: myURL)

            if (newURL.isEmpty){
                self.currentProgress += 2
                message = "Copy " +  myURL.lastPathComponent + " fail\n"
                self.DataState[index].state = .cancel
            }
            else{
                self.currentProgress += 1
                message = "Copy " +  myURL.lastPathComponent + " success\n"
                self.DataState[index].state = .insert
            }
            //Update progressbar
            DispatchQueue.main.async {
                self.progressBar.setProgress(self.currentProgress/self.totalTask, animated: true)
                self.progressBox.text += message
            }
        }
    }
    
    func insertTask(index: Int){
        DispatchQueue.global(qos: .userInteractive).sync {
            var message:String = ""
            let myURL = self.DataState[index].url
            let newURL = FileHelper.getSaveDir(fileName: self.DataState[index].url.lastPathComponent)
            let insertRes = DBHelper.shareObject.insert(id: self.DataState[index].instanceID, path: newURL.path)
            
            if insertRes{
                message = "Insert " +  myURL.lastPathComponent + " to DB success\n"
            }
            else{
                message = "Insert " +  myURL.lastPathComponent + " to DB fail\n"
            }
            
            self.currentProgress += 1
            self.DataState[index].state = .cancel
            DispatchQueue.main.async {
                self.progressBar.setProgress(self.currentProgress/self.totalTask, animated: true)
                self.progressBox.text += message
            }
        }
    }
}
