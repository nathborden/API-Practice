//
//  DataParsing.swift
//  API Practice
//
//  Created by Alveena Khoday (student LM) on 1/10/22.
//

import Foundation

class FetchData : ObservableObject{
    @Published var responses : Response = Response()

    init(){
        // this code here decodes the JSON in a much simpliler process
        
        //url from our api site, grabs daily weather. from openweathermap.com. passed imperial so temperautres are in fahrenheit which most americans (and people we are selling to) will understand
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=40.025&lon=-75.2829&exclude=alerts,minutely,hourly&units=imperial&appid=84093e05f55a9182393f95986f3b9d57")!
        
        URLSession.shared.dataTask(with: url) {(data, response, errors) in
            guard let data = data else {
                print("error")
                return 
            }
            guard let dataAsString = String(data: data, encoding: .utf8) else {return}
           
            let decoder = JSONDecoder()
           
            if let response = try? decoder.decode(Response.self, from: data) {
                DispatchQueue.main.async {
                    self.responses = response
                    }
                }
            
            //fall back incase the json is unable to be parsed
            else{
                print("can't decode JSON")
            }
            }.resume() 
    }
}
    
    struct Response: Codable{
        //sets up the structs
        var daily : [Daily] = [Daily]()
        
    }

//takes data from the json current array, has current data of weather
struct Current: Codable{
    var uvi : Double?
    var humidity : Int?
    //var temp : Double?
    //var feels_like : Double? - put this in daily instead, can change if we want to
}

struct Daily: Codable{
    var dt : Double?
    var temp: Double?
    var dew_point : Double?
    var feels_like: Double?
    var sunrise: Double?
    var sunset: Double?
    var weather: [Weather] = [Weather]()
    
}

//takes data from json weather array, has the specific types of weather
struct Weather: Codable{
    var main : String?
    var description : String?
    //not entirely sure what to put for the icon because it is an image i think
    var icon : String?
    //current.weather.icon
    //might want to change icon to URL
}


// add an extension to current, daily, and weather struct so that we can use an array of different weather informations
// to dinamically create List.
extension Current: Identifiable{
   var id: Double {return uvi!}
}
extension Daily: Identifiable{
    var id: Double {return dt!}
}

//extension Weather: Identifiable{

//}
