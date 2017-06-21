//
//  APIOperationTest.swift
//  Movi
//
//  Created by Anak Mirasing on 6/21/2560 BE.
//  Copyright © 2560 iGROOMGRiM. All rights reserved.
//

import Foundation
import Quick
import Nimble

import Moya
import RxMoya

@testable import Movi

class APIOperationTest: QuickSpec {
    
    var testProvider = RxMoyaProvider<APIService>(stubClosure: MoyaProvider.immediatelyStub, plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)])
    
    override func spec() {
        describe("Fetching object") { 
            it("emits a Response object") {
                var called = false
                let target = APIService.getMovies(page: 1)
                _ = self.testProvider.request(target).subscribe(onNext: { _ in
                    called = true
                })
                
                expect(called).to(beTrue())
            }
            
            it("emits onComplete") {
                var complete = false
                let target = APIService.getMovies(page: 1)
                
                _ = self.testProvider.request(target).subscribe(onCompleted: { _ in
                    complete = true
                })
                
                expect(complete).to(beTrue())
            }
            
            it("emits stubbed data for .getMovies(page: 1) request") {
                var responseData: Data?
                var statusCode: Int?
                let target = APIService.getMovies(page: 1)
                
                _ = self.testProvider.request(target).subscribe(onNext: { response in
                        print("response : \(response.data)")
                    responseData = response.data
                    statusCode = response.statusCode
                })
                
                expect(statusCode).to(equal(200))
                expect(responseData).to(equal(target.sampleData))
            }
            
            it("emits stubbed data for .getMovie(id: 550) request") {
                var responseData: Data?
                var statusCode: Int?
                let target = APIService.getMovie(id: 550)
                
                _ = self.testProvider.request(target).subscribe(onNext: { response in
                    responseData = response.data
                    statusCode = response.statusCode
                })
                
                expect(statusCode).to(equal(200))
                expect(responseData).to(equal(target.sampleData))
            }
        }
    }
}
