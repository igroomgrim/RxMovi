//
//  Formatter.swift
//  Movi
//
//  Created by Anak Mirasing on 6/22/17.
//  Copyright © 2017 iGROOMGRiM. All rights reserved.
//

import Foundation

func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}
