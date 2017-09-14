//
//  PickerViewExtension.swift
//  CurrencyConverterProject
//
//  Created by Елена Сермягина on 14.09.17.
//  Copyright © 2017 Елена Сермягина. All rights reserved.
//

import Foundation
import UIKit


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
       

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === neededCurrency {
            return self.currenciesExceptBase().count
        }
        
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === neededCurrency {
            return self.currenciesExceptBase()[row]
        
        }
        
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === initialCurrency {
            self.neededCurrency.reloadAllComponents()
        
        }
        self.requestCurrentCurrencyRate()
    }
    
    


}
