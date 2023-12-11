//
//  File.swift
 
//
//  Created by mac on 2022/9/29.
//

import Foundation
import Lottie
public class LOTProvideCache {

 public init() { }
 
 /// Clears the Cache.
 public func clearCache() {
   cacheMap.removeAll()
   lruList.removeAll()
 }
 
 /// The global shared Cache.
 public static let sharedCache = LOTProvideCache()
 
 /// The size of the cache.
 public var cacheSize: Int = 100
 
 public func imageProvider(forKey: String) -> AnimationImageProvider? {
   guard let imageProvider = cacheMap[forKey] else {
     return nil
   }
   if let index = lruList.firstIndex(of: forKey) {
     lruList.remove(at: index)
     lruList.append(forKey)
   }
   return imageProvider
 }
 
 public func setImageProvider(_ provider: AnimationImageProvider, forKey: String) {
   cacheMap[forKey] = provider
   lruList.append(forKey)
   if lruList.count > cacheSize {
     let removed = lruList.remove(at: 0)
     if removed != forKey {
       cacheMap[removed] = nil
     }
   }
 }
 
 fileprivate var cacheMap: [String : AnimationImageProvider] = [:]
 fileprivate var lruList: [String] = []
 
}
