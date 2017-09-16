//
//  ViewController.swift
//  CurrencyConverterProject
//
//  Created by Елена Сермягина on 14.09.17.
//  Copyright © 2017 Елена Сермягина. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fromCurLabel: UILabel!
    @IBOutlet weak var toCurLable: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
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
        
        //background blur effect
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = backgroundImg.bounds
        backgroundImg.addSubview(blurView)
        
    }
    
    
    


    //send request
    func requestCurrencyRates(baseCurrency: String, parseHandler: @escaping (Data?, Error?) -> Void){
        
        let url = URL(string: "https://api.fixer.io/latest?base=" + baseCurrency)!
        
        let dataTask = URLSession.shared.dataTask(with: url){
            (dataReceived, response, error) in
            parseHandler(dataReceived, error)
        }
        dataTask.resume()
    }
    
       
    
    //parse JSON
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
    
    
    
    // get rate
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
       
        //set indexes
        let baseCurrencyIndex = initialCurrency.selectedRow(inComponent: 0)
        let toCurrencyIndex = neededCurrency.selectedRow(inComponent: 0)
        
        //set values
        let baseCurrency = Array(names.keys)[baseCurrencyIndex]
        let toCurrency =  self.currenciesExceptBase()[toCurrencyIndex]
        
        //change lables to currencies' values
        toCurLable.text = names[toCurrency]
        fromCurLabel.text = names[baseCurrency]
        
        
       
        self.retrieveCurrencyRate(baseCurrency: baseCurrency, toCurrency: toCurrency) { [weak self] (value) in
            DispatchQueue.main.async(execute: {
                if let strongSelf = self {
                    strongSelf.currencyRelationLabel.text = value
                    strongSelf.activityIndicator.stopAnimating()
                    
                }
            })
            
        }
        
        
        
        
    }
    
    //remove base currency
    func currenciesExceptBase() -> [String] {
        var currenciesExceptBase = Array(names.keys)
        currenciesExceptBase.remove(at: initialCurrency.selectedRow(inComponent: 0))
        
        return currenciesExceptBase
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    //dictionary :(
    var names: [String:String]! = ["CAD":"Канадский доллар","BRL":"Бразильский реал", "KRW":"Южнокорейский вон", "CZK":"Чешская крона",
                 "AUD":"Австалийский доллар", "MYR":"Малайзийский ринггит", "TRY":"Турецкая лира", "MXN":"Мескисанское песо", "RUB":"Российский рубль", "BGN":"Болгарский лев", "GBP":"Британский фунт", "PHP":"Филлипинское Песо",
                 "NZD":"Новозеландский доллар", "SEK":"Шведская крона", "PLN":"Польский злотый", "THB":"Таиландский бат", "DKK":"Датская крона", "RON":"Румынский лей", "IDR":"Индонезийская рупия", "JPY":"Японская йена", "ILS":"Израильский шекель", "HRK":"Хорватская куна", "CNY":"Китайский юань", "HUF":"Венгерский форинт",
                 "HKD":"Гонконгский доллар", "CHF":"Швейцарский франк", "ZAR":"Южноафриканский ранд", "NOK":"Норвежская крона", "USD":"Доллар США","INR":"Индийская рупия", "SGD":"Сингапурский доллар", "EUR":"Евро" ]
    
  
    
    

}

