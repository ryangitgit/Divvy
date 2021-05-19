//
//  StationManager.swift
//  Divvy Mapper
//
//  Created by Ryan Weatherby on 5/4/21.
//

import Foundation
enum StationManager {
    static func fetchDivvyStations(completion: @escaping ([DivvyStation]) -> Void){
        let jsonURLString = "https://data.cityofchicago.org/resource/bbyy-e7gq.json"
        guard let url = URL(string: jsonURLString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let divvyStations = try JSONDecoder().decode([DivvyStation].self, from: data)
                DispatchQueue.main.async {
                    completion(divvyStations)
                }
            }
            catch let jsonError{
                print("Error Serializing JSON", jsonError)
            }
        }.resume()
    }
}
