//
//  ViewController.swift
//  weather app
//
//  Created by Darren Sill on 20/09/2017.
//  Copyright © 2017 darren.sill. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var resultsTextField: UILabel!
    
    var urlString:String = "http://www.weather-forecast.com/locations/"
    
    
    @IBAction func onDisplayButtonPressed(_ sender: Any) {
        
        
        
        
        var fullURL:String = urlString + locationTextField.text!.replacingOccurrences(of: " ", with: "-")
        fullURL.append("/forecasts/latest")
        
        
        if let url = URL(string: fullURL){
            
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                var message:String = ""
                
                if let err = error {
                    print(err)
                    
                    // Display Error to User
                    
                } else {
                    if let unwrappedData = data {
                        
                        let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        
                        if let contentArray = dataString?.components(separatedBy: stringSeparator){
                            
                            if contentArray.count > 1 {
                                
                                stringSeparator = "</span>"
                                
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                    
                                if newContentArray.count > 1 {
                                    
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                    print(message)
                                    
                                        
                                }
                            }
                        }
                    }
                }
                
                if message == "" {
                    message = "Weather not found. Please try again"
                }
                
                DispatchQueue.main.sync(execute: {
                    
                    self.resultsTextField.text = message
                    
                    })
            }
            
            task.resume()
            
        } else {
            
            resultsTextField.text = "Weather not found. Please try again"
            
        }
        
        
        
        //resultsTextField.text = message
        
        //Reset Text Field
        //locationTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // The following functions allow the minimisation of the keyboard when
    // user clicks outside, or the return key is pressed.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

