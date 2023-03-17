//
//  PerfectSelfWebAPI.swift
//  PerfectSelf
//
//  Created by Kayan Mishra on 3/17/23.
//  Copyright © 2023 Stas Seldin. All rights reserved.
//

import Foundation

class PerfectSelfWebAPI
{
    let PERFECTSELF_WEBAPI_ROOT:String = "http://18.119.1.15:5001/api/"

    init()
    {
        
    }
    
    deinit
    {
    }
    
    func executeAPI(with method:String, apiPath: String, json: [String: Any], completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "\(PERFECTSELF_WEBAPI_ROOT)\(apiPath)")!
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request, completionHandler:completionHandler)
        task.resume()
    }
    
    func login(email: String, password: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let json: [String: Any] = ["userName": "tester",
                                   "email": email,
                                   "password": password]
        
        //print(email, password);
        return executeAPI(with: "POST", apiPath: "Users/Login", json: json, completionHandler:completionHandler)
    }
    
    func login() -> Void
    {
        let json: [String: Any] = ["userName": "tester",
                                   "email": "tester@gmail.com",
                                   "password": "123456"]
        
        return executeAPI(with: "POST", apiPath: "Users/Login", json: json){ data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            print("ok")
//            print(data)
            if let responseJSON = responseJSON as? [String: Any] {
                //print(responseJSON["result"])
                let result = responseJSON["result"] as! CFBoolean
                if result as! Bool {
                    let user = responseJSON["user"] as? [String: Any]
                    let token = user!["token"] as? String
                    print(token!)
//                    return token!
                }
            }
        }
    }
    
    func getLibraryURLs( urls: inout [String]) -> Void
    {
    //    var request = URLRequest(url: URL(string: "https://www.example.com/api/v1")!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
    //    let config = URLSessionConfiguration.default
    //    let session = URLSession(configuration: config)
    //    let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
    //         if error != nil {
    //              print(error!.localizedDescription)
    //         }
    //         else {
    //             //print(response)//print(response ?? default "")
    //         }
    //     })
    //    task.resume()
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_12h25m22s~2023-2-3_12h25m32s-0.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_12h25m22s~2023-2-3_12h25m32s-1.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_6h25m21s~2023-2-3_6h25m32s-0.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_6h25m21s~2023-2-3_6h25m32s-1.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-05/123456789/tester1_2023-2-5_1h9m35s~2023-2-5_1h9m45s-0.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-05/123456789/tester1_2023-2-5_1h9m35s~2023-2-5_1h9m45s-1.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_6h25m21s~2023-2-3_6h25m32s-0.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_6h25m21s~2023-2-3_6h25m32s-0.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_6h25m21s~2023-2-3_6h25m32s-0.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_6h25m21s~2023-2-3_6h25m32s-0.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_6h25m21s~2023-2-3_6h25m32s-0.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_6h25m21s~2023-2-3_6h25m32s-0.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_6h25m21s~2023-2-3_6h25m32s-0.jpg")
        urls.append("https://video-thumbnail-bucket-123456789.s3.us-east-2.amazonaws.com/2023-02-03/123456789/tester2_2023-2-3_6h25m21s~2023-2-3_6h25m32s-0.jpg")
        
    }
}
