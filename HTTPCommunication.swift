////
////  HTTPCommunication.swift
////  VKAuth
////
////  Created by Kuroyan Artur on 28.10.17.
////  Copyright © 2017 Kuroyan Artur. All rights reserved.
////
//
//import Foundation
//
//class HTTPCommunication: NSObject, URLSessionDownloadDelegate
//{
//    var successBlock: (NSData) -> () = {_ in } // блок, который будет вызван, когда запрос завершится
//    
//    func retrieveURL(url: URL, successBlock: @escaping (NSData) -> ())
//    {
//        // сохраняем данный successBlock для вызова позже
//        self.successBlock = successBlock;
//        
//        // создаем запрос, используя данный url
//        let request = URLRequest(url: url as URL)
//        
//        // создаем сессию, используя дефолтную конфигурацию и устанавливая наш экземпляр класса как делегат
//        let conf = URLSessionConfiguration.default;
//        let session = URLSession(configuration: conf, delegate: self, delegateQueue: nil)
//        
//        // подготавливаем загрузку
//        let task = session.downloadTask(with: request)
//        // устанавливаем HTTP соединение
//        task.resume()
//    }
//    
//    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//        // получаем загруженные данные из локального хранилища
//        let data = NSData(contentsOf: location)
//        
//        // гарантируем, что вызов successBlock происходит в главном потоке
//        DispatchQueue.main.async {
//            // вызываем сохраненный ранее блок как колбэк
//            self.successBlock(data!)
//        }
//    }
//    
//    func postURL(url: NSURL, params:NSDictionary, successBlock: @escaping (NSData?) -> ())
//    {
//        self.successBlock = successBlock;
//    
//        // создаем временный массив для хранения POST параметров
//        let paramsArray = NSMutableArray(capacity: params.count)
//    
//        // добавляем параметры во временной массив как key=value строку
//        for (key, value) in params
//        {
//            paramsArray.add("\(key)=\(value)")
//        }
//        
//        //создаем строку из массива параметров, содержащую все параметры, разделенные символом &
//        let postBodyString = paramsArray.componentsJoined(by: "&")
//    
//        // конвертируем NSString в NSData объект, который будет использован в запросе
//        let postBodyData = NSData(bytes: postBodyString, length: postBodyString.count) //??
//        let  request = NSMutableURLRequest(url: url as URL)
//        
//        // выставляем метод запроса в POST
//        request.httpMethod = "Post"
//        
//        // выставляем content-type как form encoded
//        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "content-type")
//        
//        // добавляем созданное ранее POST тело в запрос
//        request.httpBody = postBodyData as Data
//        
//    
//        let conf = URLSessionConfiguration.default
//        let session = URLSession(configuration: conf, delegate: self, delegateQueue: nil)
//        let task = session.downloadTask(with: request.url!)
//        task.resume()
//    }
//}

