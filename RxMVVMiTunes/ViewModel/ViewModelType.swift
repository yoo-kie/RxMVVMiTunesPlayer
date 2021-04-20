//
//  ViewModelType.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/20.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get set }
    
    var input: Input { get }
    var output: Output { get }
    
    init()
}
