//
//  main.swift
//  sgetdata
//
//  Created by Brandon Plank on 7/6/21.
//

import Foundation
import ArgumentParser
import RNCryptor

extension Array where Element == UInt8 {
    func changed(orig: [UInt8]) -> Bool {
        if(orig == self){
            return false
        }
        return true
    }
    
    func asciiRep() -> String {
        var ret: String = ""
        for i in 0..<self.count {
            ret.append(String(format: "%c", self[i]))
        }
        return ret
    }
}

extension Data {
    func changed(orig: Data) -> Bool {
        if(orig == self){
            return false
        }
        return true
    }
}

struct sgetdata: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "A Swift command-line tool to get raw data into swift [UInt8](byte) format"
    )
    
    @Flag(name: [.customLong("verbose"), .customShort("v")], help: "Show extra logging for debugging purposes")
    var verbose = false
    
    @Option(name: [.customLong("string"), .customShort("s")], help: "Specifies that you are using a string.")
    var string: String?
    
    @Option(name: [.customLong("file"), .customShort("f")], help: "Specifies that you are using a file.")
    var file: String?
    
    @Flag(name: [.customLong("compress"), .customShort("c")], help: "Compress the data to save some space, uses lzma.")
    var compress = false
    
    @Option(name: [.customLong("output"), .customShort("o")], help: "Specifies the output file to put the code in.")
    var output: String?
    
    @Option(name: [.customLong("encrypt"), .customShort("e")], help: "Encrypt data using AES256 encrytion with a passkey.")
    var encrypt: String?
    
    @Option(name: [.customLong("name"), .customShort("n")], help: "Change the name of the data generated.")
    var name: String?
    
    func run() throws {
        var arrayContents = ""
        var byte = [UInt8]()
        var data: Data? = nil
        var origBytes = [UInt8]()
        var encryptStatus = false
        
        //Grab the data
        if((string) != nil){
            data = (string?.data(using: .utf8))!
        } else if((file) != nil){
            let fileUrl = URL(fileURLWithPath: file!)
            do {
                data = try Data(contentsOf: fileUrl)
            } catch {
                print("Swift get data ran into an error: \(error)")
                throw ExitCode.failure
            }
        } else {
            throw ExitCode.failure
        }
        
        // Convert data to byte array
        byte = [UInt8](data!)
        #if DEBUG
        origBytes = byte
        #endif
        // save for later to run some checks
        var oldDataTest = data; var oldByteTest = byte
        
        if compress {
            do {
                let cData = try (data! as NSData).compressed(using: .lzfse)
                data = cData as Data
                if !data!.changed(orig: oldDataTest!) {
                    print("Error updating data structures")
                    throw ExitCode.failure
                }
                byte = [UInt8](data!)
                if !byte.changed(orig: oldByteTest) {
                    print("Error updating byte structures")
                    throw ExitCode.failure
                }
                // use your compressed data
            } catch {
                print("Error compressing data!")
                throw ExitCode.failure
            }
        }
        
        // Make sure everything is up-to-date
        oldByteTest = byte; oldDataTest = data
        
        if encrypt != nil {
            let encryptedData = RNCryptor.encrypt(data: data!, withPassword: encrypt!)
            data = encryptedData as Data
            if !data!.changed(orig: oldDataTest!) {
                print("Error updating data structures")
                throw ExitCode.failure
            }
            byte = [UInt8](data!)
            if !byte.changed(orig: oldByteTest) {
                print("Error updating byte structures")
                throw ExitCode.failure
            }
        }
        
        // Set for later
        if encrypt != nil { encryptStatus = true }
        
        #if DEBUG
        print("Start debug ->")
        print("Launch args:")
        print(
"""
===========================
Verbose: \(verbose)
String: \(string ?? "None")
File: \(file ?? "None")
Compress: \(compress)
Output: \(output ?? "None")
Encrypt: \(encryptStatus)
Password: \(encrypt ?? "None")
Name: \(name ?? "data")
Bytes: \(origBytes.count)
Size of data: \(Double(origBytes.count/1000))KB
New Bytes: \(byte.count)
Size of new data: \(Double(byte.count/1000))KB

ASCII OLD:
\(origBytes.asciiRep())

ASCII NEW:
\(byte.asciiRep())
===========================
"""
        )
        print("End debug")
        // Dealloc temp var, set to empty array
        origBytes = [UInt8]()
        #endif
        
        arrayContents = byte.map { String(format: "0x%02x", $0) }.joined(separator: ", ")
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        let dateTime = formatter.string(from: now)
        if arrayContents == ""{
            arrayContents = "Error with data"
        }
        let formatterYear = DateFormatter()
        formatterYear.setLocalizedDateFormatFromTemplate("yyyy")
        let outString = """
//
//  Auto generated by sgetdata on \(dateTime)
//  sgetdata
//
//  Copyright Brandon Plank \(formatterYear.string(from: now)).
//

let \(name ?? "data"):[UInt8] = [\(arrayContents)]
"""
        if((output) != nil){
            if output!.contains(".swift"){
                do {
                    try outString.write(to: URL(fileURLWithPath: output!), atomically: true, encoding: String.Encoding.utf8)
                    print("Saved file to: \(output!)")
                } catch {
                    print("Bad file path!")
                    throw ExitCode.failure
                }
            } else {
                print("Must save as a .swift file!")
                throw ExitCode.failure
            }
            return
        } else {
            print(outString)
        }
    }
}

sgetdata.main()

