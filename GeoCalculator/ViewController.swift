//
//  ViewController.swift
//  GeoCalculator
//
//  Created by geethanjali on 5/18/18.
//  Copyright © 2018 edu.gvsu.cis. All rights reserved.
//
// Geethanjali Sanikommu , Jidnyasa Mantri
import CoreLocation
import UIKit

class ViewController: MainViewController,PickerViewControllerDelegate {

    
    @IBOutlet weak var Calculate: UIButton!
    @IBOutlet weak var Clear: UIButton!
    
    @IBOutlet weak var History: UIBarButtonItem!
    
    @IBOutlet weak var Settings: UIBarButtonItem!
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textField3: UITextField!
    @IBOutlet weak var textField4: UITextField!
    @IBOutlet weak var DUnit : UILabel!
    @IBOutlet weak var BUnit : UILabel!
    @IBOutlet weak var CalcResult: UILabel!
    @IBOutlet weak var BearingResult: UILabel!
    
    @IBOutlet weak var distUnit: UILabel!
    @IBOutlet weak var beaUnit: UILabel!
    
    var selectDistanceUnits:String = "kilometers"
    var selectBearingUnits:String = "degrees"
    var entries : [LocationLookup] = []
    @IBAction func Calculate(_ sender: UIButton) {
      
        self.calculation()
        entries.append(LocationLookup(origLat: Double(textField1.text!)!, origLng: Double(textField2.text!)!, destLat: Double(textField3.text!)!,destLng: Double(textField4.text!)!, timestamp: Date()))
        self.view.endEditing(true)
    }
    
    func settingsChanged(distanceUnit:String, bearingUnit:String){
        selectDistanceUnits = distanceUnit
        selectBearingUnits = bearingUnit
        distUnit.text = distanceUnit
        beaUnit.text = bearingUnit
        self.calculation()
    }
    
    func selectEntry(entry: LocationLookup){
        self.textField1.text = "\(entry.origLat)"
        self.textField2.text = "\(entry.origLng)"
        self.textField2.text = "\(entry.destLat)"
        self.textField4.text = "\(entry.destLng)"
        self.calculation()
    }

    func calculation() {
        
        let t1 = Double(textField1.text!)
        let t2 = Double(textField2.text!)
        let t3 = Double(textField3.text!)
        let t4 = Double(textField4.text!)
        let coordinate1 = CLLocation(latitude: t1!, longitude: t2!)
        let coordinate2 = CLLocation(latitude: t3!, longitude: t4!)
        let distanceInMeters = coordinate1.distance(from:coordinate2)
        let distanceInKilometers = (distanceInMeters * 0.001)
        let roundDkilometer = Double(round(10000*distanceInKilometers)/10000)
        let distanceInMiles = (distanceInKilometers*0.621371)
        let roundDmiles = Double(round(10000*distanceInMiles)/10000)
          if(selectDistanceUnits == "kilometers"){
           
                self.CalcResult.text = "\(roundDkilometer)"
           }
          else{
           
             self.CalcResult.text = "\(roundDmiles)"
          }
        //bearing
       
        let bearingInDegrees = bearingResult(point1:coordinate1, point2:coordinate2)
        let bearingInMils = bearingInDegrees * 17.777777777778
        let roundDegrees = Double(round(10000*(bearingInDegrees))/10000)
        let roundMils = Double(round(10000*(bearingInMils))/10000)
        if(selectBearingUnits == "degrees"){
         
            self.BearingResult.text = "\(roundDegrees)"
        }
        else {
         
            self.BearingResult.text = "\(roundMils)"
        }
     
    }
    
        func bearingResult(point1 : CLLocation, point2 : CLLocation) -> Double{
            
            let lat1 = DegreestoRadians(degrees: point1.coordinate.latitude)
            let long1 = DegreestoRadians(degrees: point1.coordinate.longitude)
            let lat2 = DegreestoRadians(degrees: point2.coordinate.latitude)
            let long2 = DegreestoRadians(degrees: point2.coordinate.longitude)
             let long = long2 - long1
            
            let y = sin(long)*cos(lat2)
            let x = cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(long)
            let radiansBearing = atan2(y,x)
            return Radianstodegrees(radians: radiansBearing)
         
        }
  
    func DegreestoRadians(degrees: Double)->Double{
        return degrees * .pi / 180.0
    }
    func Radianstodegrees(radians: Double) -> Double {
        return radians * 180.0 / .pi
    }
    
   
    
    @IBAction func ClearValues(_ sender: UIButton) {
        textField1.text = ""
        textField2.text = ""
        textField3.text = ""
        textField4.text = ""
        CalcResult.text = ""
        BearingResult.text = ""
        textField1.isEnabled = true
        textField2.isEnabled = true
        textField3.isEnabled = true
        textField4.isEnabled = true
        self.view.endEditing(true)
    }
    
    
  /*  @IBAction func Settingspressed(_ sender: Any) {
        performSegue(withIdentifier: "mySegue", sender: self)
    }*/
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if let unit = segue.destination.childViewControllers[0] as? PickerViewController {
//        unit.Unit1 = self.selectDistanceUnits
//        unit.Unit2 = self.selectBearingUnits
//        unit.delegate = self
//        }
//    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if(segue.identifier == "historySegue")
        {
            if let unit = segue.destination as? HistoryTableViewController {
            
            unit.entries = self.entries
            unit.historyDelegate = self as? HistoryTableViewControllerDelegate
        }
        }
        else if(segue.identifier == "settingsSegue")
        {
            if let unit = segue.destination as? PickerViewController {
                unit.Unit1 = self.selectDistanceUnits
                unit.Unit2 = self.selectBearingUnits
                unit.delegate = self
        }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // dismiss keyboard when tapping outside oftext fields
        
        distUnit.text = selectDistanceUnits
        beaUnit.text = selectBearingUnits
        
        let detectTouch = UITapGestureRecognizer(target: self, action:
            #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(detectTouch)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }


}

