//
//  ViewController.swift
//  CurrencyConverterProject
//
//  Created by Елена Сермягина on 14.09.17.
//  Copyright © 2017 Елена Сермягина. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let currencies = ["RUB", "USD", "EUR"]


    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var currencyRelationLabel: UILabel!
    
    @IBOutlet weak var initialCurrency: UIPickerView!
    @IBOutlet weak var neededCurrency: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        initialCurrency.dataSource = self
        initialCurrency.delegate = self
        neededCurrency.dataSource = self
        neededCurrency.delegate = self
        
        activityIndicator.hidesWhenStopped = true
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    func requestCurrencyRates(baseCurrency: String, parseHandler: @escaping (Data?, Error?) -> Void){
        let url = URL(string: "https://api.fixer.io/latest?base=" + baseCurrency)!
        
        let dataTask = URLSession.shared.dataTask(with: url){
            (dataReceived, response, error) in
            parseHandler(dataReceived, error)
        }
        dataTask.resume()
    }
    
    func parseCurrencyRatesResponse(data: Data?, toCurrency: String) -> String {
        var value: String = ""
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,Any>
            if let parsedJSON = json {
                print("\(parsedJSON)")
                if let rates = parsedJSON["rates"] as? Dictionary<String, Double> {
                    if let rate = rates[toCurrency] {
                        value = "\(rate)"
                    } else {
                        value = "No rate fo currency \"\(toCurrency)\" found"
                    }
                } else {
                    value = " No \"rates\" field found "
                }
            } else {
                value = "No JSON value parsed"
            }
        } catch {
            
            value = error.localizedDescription
        }
        
        return value
    }
    
    
    func retrieveCurrencyRate(baseCurrency: String, toCurrency: String, completion: @escaping (String) -> Void){
        self.requestCurrencyRates(baseCurrency: baseCurrency){ [weak self] (data, error) in
            var string = "No currency retrieved!"
            
            if let currentError = error {
                string = currentError.localizedDescription
            } else {
                if let strongSelf = self {
                    string = strongSelf.parseCurrencyRatesResponse(data: data, toCurrency: toCurrency)
                }
                
            }
            completion(string)
        }
        
    }
    
    
    func requestCurrentCurrencyRate(){
        
        activityIndicator.startAnimating()
        
        currencyRelationLabel.text = " "
        
        let baseCurrencyIndex = initialCurrency.selectedRow(inComponent: 0)
        let toCurrencyIndex = neededCurrency.selectedRow(inComponent: 0)
        
        let baseCurrency = self.currencies[baseCurrencyIndex]
        let toCurrency = self.currenciesExceptBase()[toCurrencyIndex]
        
        
        self.retrieveCurrencyRate(baseCurrency: baseCurrency, toCurrency: toCurrency) { [weak self] (value) in
            DispatchQueue.main.async(execute: {
                if let strongSelf = self {
                    strongSelf.currencyRelationLabel.text = value
                    strongSelf.activityIndicator.stopAnimating()
                    
                }
            })
            
        }
        
        
        
        
    }
    

    func currenciesExceptBase() -> [String] {
        var currenciesExceptBase = currencies
        currenciesExceptBase.remove(at: initialCurrency.selectedRow(inComponent: 0))
        
        return currenciesExceptBase
    }
  
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

