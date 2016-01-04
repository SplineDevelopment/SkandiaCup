//
//  SharingManager.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class SharingManager{
    static let soap : Soap = (Config.soapMock ? SoapMock() : SoapImpl())
    static let cache : Cache = (Config.soapMock ? CacheMock() : CacheImpl())
    static let data : DataManager = DataManager()
    static let insta : InstagramRepo = (Config.soapMock ? InstagramRepoMock() : InstagramRepoImpl())
    static let rssfeed : RSS = RSS()
    static let locale: LocaleManager = LocaleManager()
}