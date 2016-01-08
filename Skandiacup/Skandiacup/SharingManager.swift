//
//  SharingManager.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
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