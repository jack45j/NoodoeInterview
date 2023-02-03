//
//  Router.swift
//  NoodoeInterview
//
//  Created by 林翌埕-20001107 on 2023/2/3.
//

import Foundation

protocol Router: Presentable {
  func present(_ module: Presentable?)
  func present(_ module: Presentable?, animated: Bool)
  
  func push(_ module: Presentable?)
  func push(_ module: Presentable?, hideBottomBar: Bool)
  func push(_ module: Presentable?, animated: Bool)
  func push(_ module: Presentable?, animated: Bool, completion: (() -> Void)?)
  func push(_ module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?)
  
  func popModule()
  func popModule(animated: Bool)
  
  func dismissModule()
  func dismissModule(animated: Bool, completion: (() -> Void)?)
  
  func setRootModule(_ module: Presentable?)
  func setRootModule(_ module: Presentable?, hideBar: Bool)
  
  func popToRootModule(animated: Bool)
}
