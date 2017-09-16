//
//  PickerViewExtension.swift
//  CurrencyConverterProject
//
//  Created by Елена Сермягина on 14.09.17.
//  Copyright © 2017 Елена Сермягина. All rights reserved.
//

import Foundation
import UIKit


extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate  {
    
    
    
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         if pickerView === neededCurrency {
            return self.currenciesExceptBase().count
        }
        
        return Array(names.keys).count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
          if pickerView === neededCurrency {
        
            return self.currenciesExceptBase()[row]
        
         }
        
        return Array(names.keys)[row]
    }
 
    
  /* adjusted pickerView
     
     func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        

        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 170, height: 170))
        
        let middleLabel = UILabel(frame: CGRect(x: 0, y: -2, width: 170, height: 140))
        middleLabel.text = currencies[row]
        middleLabel.textColor = .white
        middleLabel.textAlignment = .center
        middleLabel.font = UIFont.systemFont(ofSize: 28, weight: UIFontWeightThin)
        view.addSubview(middleLabel)
        
        
        let bottomLabel = UILabel(frame: CGRect(x: 0, y: 70, width: 170, height: 30))
        bottomLabel.text = names[row]
        bottomLabel.textColor = .white
        bottomLabel.textAlignment = .center
        bottomLabel.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightThin)
        view.addSubview(bottomLabel)
 
        
        return view
    }
    */
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
        if pickerView === initialCurrency {
            
           
            self.neededCurrency.reloadAllComponents()
            
        }
        self.requestCurrentCurrencyRate()
    }
    
   
    
 


}
