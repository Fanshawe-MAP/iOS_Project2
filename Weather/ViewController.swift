//
//  ViewController.swift
//  Weather
//
//  Created by Sagar Modi on 19/07/2023.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var tempSelector: UISegmentedControl!
    
    @IBOutlet weak var tempButton: UIButton!
    
    @IBOutlet weak var searchText: UITextField!
    
    @IBOutlet weak var wallpaperImageView: UIImageView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var myLocation:String = ""
    var celcius:Double = 0
    var farenhit:Double = 0
    var day:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setNeedsStatusBarAppearanceUpdate()
        location.text = ""
        tempLabel.text = ""
        conditionLabel.text = ""
        tempButton.isEnabled = false
        searchText.delegate = self
        getCurrentTime()
        setupLocation()
    }
    
    func getCurrentTime(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let result = dateFormatter.string(from: date)
        if let time = Int(result){
            if(time>6 && time<20){
                day = true
                wallpaperImageView.image = UIImage(named: "day")
            }else{
                day = false
                wallpaperImageView.image = UIImage(named: "night")
                location.textColor = UIColor.white
                tempLabel.textColor = UIColor.white
                conditionLabel.textColor = UIColor.white
            }
        }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil {
            currentLocation = locations.last
            
            if let curLocation = currentLocation {
                let lat = curLocation.coordinate.latitude
                let long = curLocation.coordinate.longitude
                myLocation = "\(lat),\(long)"
                location.text = myLocation
                tempButton.isEnabled = true
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func getUrl(Location:String)->URL?{
        let baseUrl = "https://api.weatherapi.com/v1/"
        let endPoint = "current.json"
        let apiKey = "3b4bf688673b4f32bff235820231907"
        let search = Location
        
        let url = "\(baseUrl)\(endPoint)?key=\(apiKey)&q=\(search)"
        
        return URL(string: url)
    }
    

    @IBAction func getLocation(_ sender: UIButton) {
        setupLocation()
    }
    
    
    
    @IBAction func tempButton(_ sender: UIButton) {
        let url = getUrl(Location: myLocation)
        
        guard let url = url else{
            print("error")
            return
        }
        
        let urlSession = URLSession.shared
        let dataTask = urlSession.dataTask(with: url) { data, response, error in
            
            guard let data = data else{
                print("No data")
                return
            }
            
            if let data = self.parseJson(data: data){
                
                DispatchQueue.main.async {
                    self.location.text = data.location.name
                    self.celcius = data.current.temp_c
                    self.farenhit = data.current.temp_f
                    self.tempLabel.text = String(data.current.temp_c)
                    self.conditionLabel.text = data.current.condition.text
                    self.iconSelector(code: data.current.condition.code)
                    //self.iconSelector(code: 1135)
                    print(data.current.condition.code)
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    @IBAction func tempSelector(_ sender: UISegmentedControl) {
        if (tempSelector.selectedSegmentIndex == 0){
            tempLabel.text = String(celcius)
        }else {
            tempLabel.text = String(farenhit)
        }
    }
    
    func parseJson(data:Data)-> Weather?{
        let decoder = JSONDecoder()
        var weatherResponse:Weather?
        
        do{
            weatherResponse = try decoder.decode(Weather.self, from: data)
        }catch{
            print(error)
        }
        return weatherResponse
    }
    
    func iconSelector(code:Int){
        
        switch code{
        case 1000:
            if(day==true){
                let config = UIImage.SymbolConfiguration(paletteColors: [.orange])
                image.preferredSymbolConfiguration = config
                image.image = UIImage(systemName: "sun.max.fill")
            }else if(day==false){
                let config = UIImage.SymbolConfiguration(paletteColors: [.white])
                image.preferredSymbolConfiguration = config
                image.image = UIImage(systemName: "moon.fill")
            }
        case 1003,1006:
            if(day==true){
                let config = UIImage.SymbolConfiguration(paletteColors: [.white,.orange])
                image.preferredSymbolConfiguration = config
                image.image = UIImage(systemName:  "cloud.sun.fill")
            }else if(day==false){
                let config = UIImage.SymbolConfiguration(paletteColors: [.white,.blue])
                image.preferredSymbolConfiguration = config
                image.image = UIImage(systemName:  "cloud.moon.fill")
            }
        case 1009:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.fill")
        case 1030:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.fog.fill")
        case 1063,1180:
            if(day==true){
                let config = UIImage.SymbolConfiguration(paletteColors: [.white,.orange,.blue])
                image.preferredSymbolConfiguration = config
                image.image = UIImage(systemName:  "cloud.sun.rain.fill")
            }else if(day==false){
                let config = UIImage.SymbolConfiguration(paletteColors: [.white,.blue])
                image.preferredSymbolConfiguration = config
                image.image = UIImage(systemName:  "cloud.moon.rain.fill")
            }
        case 1066,1210:
            if(day==true){
                let config = UIImage.SymbolConfiguration(paletteColors: [.white,.orange])
                image.preferredSymbolConfiguration = config
                image.image = UIImage(systemName:  "sun.snow.fill")
            }else if(day==false){
                let config = UIImage.SymbolConfiguration(paletteColors: [.white,.blue])
                image.preferredSymbolConfiguration = config
                image.image = UIImage(systemName:  "moon.dust.fill")
            }
        case 1069,1204,1207,1237,1249,1252,1261,1264:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.sleet.fill")
        case 1072,1150,1153,1168,1171:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white,.blue])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.drizzle.fill")
        case 1087,1273,1276:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white,.blue])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.bolt.rain.fill")
        case 1114:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "wind.snow")
        case 1117,1213,1216,1219,1222,1225,1255,1258,1279,1282:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.snow.fill")
        case 1135,1147:
            if(day==true){
                let config = UIImage.SymbolConfiguration(paletteColors: [.white,.orange])
                image.preferredSymbolConfiguration = config
                image.image = UIImage(systemName:  "sun.haze.fill")
            }else if(day==false){
                let config = UIImage.SymbolConfiguration(paletteColors: [.white,.blue])
                image.preferredSymbolConfiguration = config
                image.image = UIImage(systemName:  "moon.haze.fill")
            }
        case 1183,1186,1189,1192,1198,1201,1240,1243,1246:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white,.blue])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.rain.fill")
        case 1195:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white,.blue])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.heavyrain.fill")
        default:
            image.image = UIImage(systemName:  "sun.max.fill")
        }
        
    }
    
    struct Weather:Decodable{
        let location:Location
        let current:Current
    }
    
    struct Location: Decodable{
        let name:String
    }
    
    struct Current: Decodable{
        let temp_c:Double
        let temp_f:Double
        let condition:Condition
    }
    
    struct Condition: Decodable{
        let text:String
        let code:Int
    }
    
}

