//
//  XMLParser.swift
//  XMPApp
//
//  Created by Vu Duy on 09/07/2021.
//

import UIKit
class HNXMLParser: NSObject, XMLParserDelegate {
    var xmlParser: XMLParser!
    var currentElement:String?

    // output parsing result
    var parsingResult:String = ""

    func startParsingFileFromURL(url: URL)-> String {
        self.xmlParser = XMLParser(contentsOf: url)
        self.xmlParser.delegate = self
        let result = self.xmlParser.parse()
        print("Parsed from URL result: \(result)")
        if result == false {
            print(xmlParser.parserError!.localizedDescription)
        }
        return parsingResult
    }

    //MARK: XMLParserDelegate

    // start document
    func parserDidStartDocument(_ parser: XMLParser) {
        print("parserDidStartDocument")
    }

    // start element <key>
    func parser(_ parser: XMLParser, didStartElement elementName: String,
    namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
    }

    // found value of element <key>value</key>
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElement == "instanceid" || currentElement == "instanceID"{
            parsingResult = string
        }
    }

    // end element </key>
    func parser(_ parser: XMLParser, didEndElement elementName: String,
    namespaceURI: String?, qualifiedName qName: String?) {

    }

    // end document
    func parserDidEndDocument(_ parser: XMLParser) {
        parser.abortParsing()
        xmlParser = nil
        print("parserDidEndDocument")
    }
}

//func startParsingFile(url: URL)-> String {
//    guard let parser = Foundation.XMLParser(contentsOf: url) else {
//        //...
//        return instanceID
//    }
//    parser.delegate = self
//    let result = parser.parse()
//    print("Parsed from file result: \(result)")
//    if result == false {
//        print(parser.parserError?.localizedDescription)
//    }
//    return instanceID
//}
