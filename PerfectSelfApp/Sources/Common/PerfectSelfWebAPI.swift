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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if method != "GET" {
            request.httpBody = jsonData
            request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler:completionHandler)
        task.resume()
    }
    
    func login(userType: Int, email: String, password: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let json: [String: Any] = ["userType": userType,// 3 for actor, 4 for reader
                                   "email": email,
                                   "password": password]
        
        //print(email, password);
        return executeAPI(with: "POST", apiPath: "Users/Login", json: json, completionHandler:completionHandler)
    }
    
    func signup(userType: Int, userName: String, firstName: String, lastName: String, email: String, password: String, phoneNumber: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let json: [String: Any] = [
            "userType": userType,
            "userName": userName,
            "email": email,
            "password": password,
            "firstName": firstName,
            "lastName": lastName,
            "dateOfBirth": "",
            "gender": 0,
            "currentAddress": "",
            "permanentAddress": "",
            "city": "",
            "nationality": "",
            "phoneNumber": phoneNumber,
            "isLogin": false,
            "token": "",
            "isDeleted": false,
        ]
        return executeAPI(with: "POST", apiPath: "Users", json: json, completionHandler:completionHandler)
    }

    func createActorProfile(actoruid: String, ageRange: String, height: String, weight: String, country: String, state: String, city: String, agency: String, vaccination: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let json: [String: Any] = [
            "isDeleted": false,
              "title": "",
            "actorUid": actoruid,
            "ageRange": ageRange,
            "height": Int(height) ?? 0,
            "weight": Int(weight) ?? 0,
            "country": country,
            "state": state,
            "city": city,
            "agencyCountry": agency,
            "vaccinationStatus": Int(vaccination) ?? 0,
        ]
        return executeAPI(with: "POST", apiPath: "ActorProfiles/", json: json, completionHandler:completionHandler)
    }
    func getReaders(readerName: String?, isOnline: Bool?, availableTimeSlotType: Int?, availableFrom: String?, availableTo: String?, minPrice: Float?, maxPrice: Float?, gender: Int?, sortBy: Int?, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        var params = ""
        var isParamsExist = false
        if readerName != nil {
            isParamsExist = true
            params += "readerName=\(readerName!)"
        }
        if isOnline != nil {
            params += (isParamsExist ? "":"&") + "isOnline=\(isOnline!)"
            isParamsExist = true
        }
        if availableTimeSlotType != nil {
            params += (isParamsExist ? "":"&") + "availableTimeSlotType=\(availableTimeSlotType!)"
            isParamsExist = true
        }
        if availableFrom != nil {
            params += (isParamsExist ? "":"&") + "availableFrom=\(availableFrom!)&availableTo=\(availableTo!)"
            isParamsExist = true
        }
        if minPrice != nil {
            params += (isParamsExist ? "":"&") + "minPrice=\(minPrice!)&maxPrice=\(maxPrice!)"
            isParamsExist = true
        }
        if gender != nil {
            params += (isParamsExist ? "":"&") + "gender=\(gender!)"
            isParamsExist = true
        }
        if sortBy != nil {
            params += (isParamsExist ? "":"&") + "sortBy=\(sortBy!)"
            isParamsExist = true
        }
        return executeAPI(with: "GET", apiPath: "ReaderProfiles/ReaderList?\(params)", json: [:], completionHandler:completionHandler)
    }
    func getReaderById(id: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        return executeAPI(with: "GET", apiPath: "ReaderProfiles/Detail/\(id)", json: [:], completionHandler:completionHandler)
    }
    func createReaderProfile(readeruid: String, title: String, about: String, hourlyprice: String, skills: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let json: [String: Any] = [
            "isDeleted": false,
            "title": title,
            "readerUid": readeruid,
            "hourlyPrice": Int(hourlyprice) ?? 0,
            "voiceType": 0,
            "others": 0,
            "about": about,
            "skills": skills,
        ]
        return executeAPI(with: "POST", apiPath: "ReaderProfiles/", json: json, completionHandler:completionHandler)
    }

    func editReaderProfileAbout(uid: String, about: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let json: [String: Any] = [
            "isDeleted": false,
            "title": "",
            "readerUid": uid,
            "hourlyPrice": -1,
            "voiceType": -1,
            "others": -1,
            "about": about,
            "skills": "",
        ]
        return executeAPI(with: "PUT", apiPath: "ReaderProfiles/\(uid)", json: json, completionHandler:completionHandler)
    }
    
    func editReaderProfileTitle(uid: String, title: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let json: [String: Any] = [
            "isDeleted": false,
            "title": title,
            "readerUid": uid,
            "hourlyPrice": -1,
            "voiceType": -1,
            "others": -1,
            "about": "",
            "skills": "",
        ]
        return executeAPI(with: "PUT", apiPath: "ReaderProfiles/\(uid)", json: json, completionHandler:completionHandler)
    }
    
    func editReaderHourlyRate(uid: String, hourlyRate: Int, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let json: [String: Any] = [
            "isDeleted": false,
            "title": "",
            "readerUid": uid,
            "hourlyPrice": hourlyRate,
            "voiceType": -1,
            "others": -1,
            "about": "",
            "skills": "",
        ]
        return executeAPI(with: "PUT", apiPath: "ReaderProfiles/\(uid)", json: json, completionHandler:completionHandler)
    }
    
    func editReaderProfileName(uid: String, username: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let json: [String: Any] = [
            "id": 0,
            "isDeleted": true,
            "createdTime": "2023-03-28T14:05:15.103Z",
            "updatedTime": "2023-03-28T14:05:15.103Z",
            "deletedTime": "2023-03-28T14:05:15.103Z",
            "uid": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
            "userType": -1,
            "userName": username,
            "email": "string",
            "password": "",
            "firstName": "",
            "lastName": "",
            "dateOfBirth": "",
            "gender": 0,
            "currentAddress": "",
            "permanentAddress": "",
            "city": "",
            "nationality": "",
            "phoneNumber": "",
            "isLogin": true,
            "token": "string"
        ]
        
        return executeAPI(with: "PUT", apiPath: "Users/\(uid)", json: json, completionHandler:completionHandler)
    }
    func bookAppointment(actorUid: String, readerUid: String, bookStartTime: String,bookEndTime: String, script: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
                
        let json: [String: Any] = [
  
            "actorUid": actorUid,
            "readerUid": readerUid,
            "bookStartTime": bookStartTime,
            "bookEndTime": bookEndTime,
            "scriptFile": script,
        ]
   
        return executeAPI(with: "POST", apiPath: "Books/", json: json, completionHandler:completionHandler)
    }
    func getBookingsByUid(uid: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        return executeAPI(with: "GET", apiPath: "Books/DetailList/ByUid/\(uid)", json: [:], completionHandler:completionHandler)
    }
    func cancelBookingByRoomUid(uid: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        return executeAPI(with: "DELETE", apiPath: "Books/ByRoomUid/\(uid)", json: [:], completionHandler:completionHandler)
    }
    func getAvailabilityById(uid: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        return executeAPI(with: "GET", apiPath: "Availabilities/UpcomingByUid/\(uid)/\(Date.getCurrentDate())", json: [:], completionHandler:completionHandler)
    }
    func getLibraryByUid(uid: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        return executeAPI(with: "GET", apiPath: "Library/ByUid/\(uid)", json: [:], completionHandler:completionHandler)
    }

    func addAvailability(uid: String, date: String, fromTime: String, toTime: String, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> Void
    {
        let json: [String: Any] = [
            "readerUid": uid,
            "isDeleted": false,
            "date": date,
            "fromTime": fromTime,
            "toTime": toTime
        ]
        return executeAPI(with: "POST", apiPath: "Availabilities/", json: json, completionHandler:completionHandler)
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
    
    func addLibrary(uid: String, tapeName: String, bucketName: String, tapeKey: String) -> Void
    {
        let json: [String: Any] = ["readerUid": uid,
                                   "tapeName": tapeName,
                                   "bucketName": bucketName,
                                   "tapeKey": tapeKey]
        
        return executeAPI(with: "POST", apiPath: "Library", json: json){ data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let _ = try? JSONSerialization.jsonObject(with: data, options: [])
//            print("ok")
//            print(data)
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
