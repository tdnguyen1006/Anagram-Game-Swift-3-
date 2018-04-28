//
//  DBManager.swift
//  ANAGRAM-GROUP8
//
//  Created by Tech on 2018-04-17.
//  Copyright © 2018 Tech. All rights reserved.
//

import Foundation

import SQLite3

class DBManager{
    
    var db: OpaquePointer?
    
    init(){
        
        //create and open database
        
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("anagramlibrary.sqlite")
        
        print(url)
        //create or open the file
        if sqlite3_open(url.path, &db) != SQLITE_OK{
            print("Error creating database")
        }
        if sqlite3_exec(db,
                        "DROP TABLE IF EXISTS anagram",nil,nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print("error createing the table: \(err)")
        }
        if sqlite3_exec(db,
                        "CREATE TABLE anagram (id INTEGER PRIMARY KEY AUTOINCREMENT, word varchar(20), anagramWord varchar(20))",nil,nil, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print("error createing the table: \(err)")
        }
        
        var word = [[NSString:[String]]]()
        word = [["drawer":["redraw", "reward", "warred", "warder"]], ["abets":["beast", "bates","beats","baste"]], ["arches":["chares","chaser","raches","search"]], ["threads":["hardest", "hardset", "hatreds", "trashed"]], ["canters":["nectars", "recants", "carnets", "scanter"]]]
       
        
        for item in word {
            for dictionary in item
            {
                //print(dictionary)
                for value in dictionary.value
                {
                    //print(dictionary.key + " " + value)
                    insertItem(word: dictionary.key, anagramWord: value)
                }
            }
        }
    }
    
    func insertItem(word:NSString, anagramWord:String){
        
        var stm: OpaquePointer?
        let query = "INSERT INTO anagram (word,anagramWord) VALUES (?,?)"
        
        
        if sqlite3_prepare(db, query, -1, &stm, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print("error prepareing: \(err)")
            return
        }
        
        if sqlite3_bind_text(stm, 1, (word as NSString).utf8String, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print("error binding: \(err)")
            return
        }
        
        if sqlite3_bind_text(stm, 2, anagramWord, -1, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print("error binding: \(err)")
            return
        }
        
        if sqlite3_step(stm) != SQLITE_DONE{
            let err = String(cString: sqlite3_errmsg(db))
            
            print("error insering item: \(err)")
            return
        }
        
        if sqlite3_finalize(stm) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print("error finalizing: \(err)")
            return
        }
        //print(word as NSString + " " + anagramWord)
    }
    
    func selectKey()->[String]{
        
        //select data from the database and return as an array of tuples
        var stm: OpaquePointer?
        let query = "SELECT Distinct word FROM anagram"
        if sqlite3_prepare_v2(db, query, -1, &stm, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print("error prepareing select: \(err)")
        }
        
        var res = [String]()
        while sqlite3_step(stm) == SQLITE_ROW{
            let word = String(cString: sqlite3_column_text(stm, 0))
            res.append(word)
        }
        
        if sqlite3_finalize(stm) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print("error finalizing: \(err)")
        }
        
        return res
        
    }
    
    func selectValue(word:String)->[String]{
        var stm: OpaquePointer?
        let query = "SELECT anagramWord From anagram where word = '" + word + "'"
        if sqlite3_prepare_v2(db, query, -1, &stm, nil) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print("error prepareing select: \(err)")
        }
        
        var res = [String]()
        while sqlite3_step(stm) == SQLITE_ROW{
            let anagramWord = String(cString: sqlite3_column_text(stm, 0))
            res.append(anagramWord)
        }
        
        if sqlite3_finalize(stm) != SQLITE_OK{
            let err = String(cString: sqlite3_errmsg(db))
            print("error finalizing: \(err)")
        }
        return res
    }
    
}
