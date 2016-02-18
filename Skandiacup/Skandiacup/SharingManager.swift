//
//  SharingManager.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class SharingManager{
    static var config: Config = Config();
    static let soap : Soap = (config.soapMock ? SoapMock() : SoapImpl())
    static let cache : Cache = (config.soapMock ? CacheMock() : CacheImpl())
    static let data : DataManager = DataManager()
    static let insta : InstagramRepo = (config.soapMock ? InstagramRepoMock() : InstagramRepoImpl())
    static let rssfeed : RSS = RSS()
    static let locale: LocaleManager = LocaleManager()
}