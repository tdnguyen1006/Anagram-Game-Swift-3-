//
//  ViewController.swift
//  ANAGRAM-GROUP8
//
//  Created by Tech on 2018-03-19.
//  Copyright © 2018 Tech. All rights reserved.
//


/***********************************************************************************************************************************************************************
 ANAGRAM Final Project
 Developed by:
 
 Toan Nguyen        ID: 100979753
 Mentesnot Aboset   ID: 101022050
 Jiacheng Lei       ID: 101015906
 
 Date: April 23, 2018
 
 Comments provided by Prof. Pawluk: Store the words in a persistent storage, display the correct input answer.
 ***********************************************************************************************************************************************************************/

import UIKit

class ViewController: UIViewController {
    
   
    var db:DBManager?

    var keys = [String]()
    var anagramWords = [String]()
    var dic = [String:[String]]()
    var word: (key:String, value:[String])?
    var array = [String]()
    var score = Int()
    
    @IBOutlet weak var hintText: UILabel!
    @IBOutlet weak var feedbackText: UILabel!
    @IBOutlet weak var inputTextBox: UITextField!
    

    @IBOutlet weak var scoreText: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var answerText: UILabel!
    
    @IBOutlet weak var btnSkip: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = DBManager()
        keys = (db?.selectKey())!
        
        
        for key in keys
        {
            anagramWords = (db?.selectValue(word: key))!
            dic[key] = anagramWords
        }
        print(dic)
        feedbackText.text = ""
        answerText.text = ""
        
        inputTextBox.autocorrectionType = .no
        
        word = dic.popFirst()
        hintText.text = word?.key.uppercased()
        btnNext.isEnabled = false
        btnNext.backgroundColor = UIColor.gray
        score = 0
        scoreText.text = "Score: \(score)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submit(_ sender: UIButton) {
        if(word?.value.contains(inputTextBox.text!.lowercased()))!
        {
            if(array.contains(inputTextBox.text!.uppercased()))
            {
                feedbackText.text = "You already submited this answer."
                feedbackText.textColor = UIColor.red
            }
            else
            {
                array.append(inputTextBox.text!.uppercased())
                score += 5
                if(answerText.text == "")
                {
                    answerText.text = inputTextBox.text!.uppercased()
                }
                else
                {
                    answerText.text? += " - " + inputTextBox.text!.uppercased()
                }
                
                if(array.count == 4)
                {
                    if(dic.count == 0)
                    {
                        var count = 4 - array.count
                        feedbackText.text = "Correct. \(count) more to go"
                        if(array.count == 4)
                        {
                            feedbackText.text = "Congratulation. You have completed the game. Your score: \(score)"
                            feedbackText.textColor = UIColor.green
                        }
                        btnSkip.isEnabled = false
                        btnSkip.backgroundColor = UIColor.gray
                        btnNext.isEnabled = false
                        btnNext.backgroundColor = UIColor.gray
                    }
                    else
                    {
                        feedbackText.text = "Correct. Click next to move to the next word"
                        btnNext.isEnabled = true
                        btnNext.backgroundColor = UIColor.brown
                    }
                }
                else
                {
                    var count = 4 - array.count
                    feedbackText.text = "Correct. \(count) more to go"
                    btnNext.isEnabled = false
                    btnNext.backgroundColor = UIColor.gray
                }
                
                scoreText.text = "Score: \(score)"
                feedbackText.textColor = UIColor.green
            }
        }else{
            feedbackText.text = "Incorrect!"
            feedbackText.textColor = UIColor.red
            btnNext.isEnabled = false
            btnNext.backgroundColor = UIColor.gray
        }
    }
    
    func nextWord()
    {
        if(dic.count > 0)
        {
            word = dic.popFirst()
            hintText.text = word?.key.uppercased()
            feedbackText.text = ""
            answerText.text = ""
            btnNext.isEnabled = false
            btnNext.backgroundColor = UIColor.gray
            array.removeAll()
            if(dic.count == 0)
            {
                btnSkip.isEnabled = false
                btnSkip.backgroundColor = UIColor.gray
            }
        }
        else
        {
            btnNext.isEnabled = false
            btnNext.backgroundColor = UIColor.gray
        }
    }
    
    @IBAction func btnSkip(_ sender: UIButton) {
        nextWord()
    }
    
    @IBAction func btnNext(_ sender: UIButton) {
        nextWord()
    }
    
    
   
    

}

