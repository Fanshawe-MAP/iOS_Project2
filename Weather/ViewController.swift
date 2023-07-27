//
//  ViewController.swift
//  Weather
//
//  Created by Sagar Modi on 19/07/2023.
//

import UIKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var image: UIImageView!

    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var location: UILabel!
    
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var tempSelector: UISegmentedControl!
    
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    var myLocation:String = ""
    var celcius:Double = 0
    var farenhit:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupLocation()
        tempLabel.text = ""
        conditionLabel.text = ""
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
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    func getUrl()->URL?{
        let baseUrl = "https://api.weatherapi.com/v1/"
        let endPoint = "current.json"
        let apiKey = "3b4bf688673b4f32bff235820231907"
        let search = myLocation
        
        let url = "\(baseUrl)\(endPoint)?key=\(apiKey)&q=\(search)"
        
        return URL(string: url)
    }
    
    @IBAction func tempButton(_ sender: UIButton) {
        let url = getUrl()
        
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
            let config = UIImage.SymbolConfiguration(paletteColors: [.orange])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName: "sun.max.fill")
        case 1003:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white,.orange])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.sun.fill")
        case 1006,1009:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.fill")
        case 1030:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1063:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white,.orange,.blue])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.sun.rain.fill")
        case 1066:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white,.orange])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "sun.snow.fill")
        case 1069:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.sleet.fill")
        case 1072:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white,.blue])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.drizzle.fill")
        case 1087:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white,.blue])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.bolt.rain.fill")
        case 1114:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "wind.snow")
        case 1117:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "cloud.snow.fill")
        case 1135:
            let config = UIImage.SymbolConfiguration(paletteColors: [.white,.orange])
            image.preferredSymbolConfiguration = config
            image.image = UIImage(systemName:  "sun.haze.fill")
        case 1147:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1150:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1153:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1168:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1171:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1180:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1183:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1186:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1189:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1192:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1195:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1198:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1201:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1204:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1207:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1210:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1213:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1216:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1219:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1222:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1225:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1237:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1240:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1243:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1246:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1249:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1252:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1255:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1258:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1261:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1264:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1273:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1276:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1279:
            image.image = UIImage(systemName:  "sun.max.fill")
        case 1282:
            image.image = UIImage(systemName:  "sun.max.fill")
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

