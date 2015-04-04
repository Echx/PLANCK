//
//  GOOpticRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOOpticRep: NSObject {
    var id: String
    var edges = [GOSegment]()
    var type = DeviceType.Mirror
    var bezierPath: UIBezierPath {
        get {
            var path = UIBezierPath()
            for edge in self.edges {
                path.appendPath(edge.bezierPath)
            }
            return path
        }
    }
    
    var numOfEdges : Int {
        get {
            return edges.count
        }
    }
    
    var refractionIndex : CGFloat = GOConstant.vacuumRefractionIndex

    
    init(id: String) {
        self.id = id
        super.init()
    }
    
    init(refractionIndex: CGFloat, id: String) {
        self.id = id
        self.refractionIndex = refractionIndex
        super.init()
        self.updateEdgesParent()
    }
    
    func setDirection(direction: CGVector) {
        fatalError("setDirection must be overridden by child classes")
    }
    
    func setDeviceType(type: DeviceType) {
        self.type = type
        self.updateEdgesType()
    }
    
    func containsPoint(point: CGPoint) -> Bool {
        fatalError("containsPoint must be overriden by child classes")
    }
    
    func updateEdgesParent() {
        for edge in self.edges {
            edge.parent = self.id
        }
    }
    
    private func updateEdgesType() {
        for edge in self.edges {
            switch self.type {
            case DeviceType.Mirror:
                edge.willReflect = true
                edge.willRefract = false
            case DeviceType.Lens:
                edge.willReflect = false
                edge.willRefract = true
            case DeviceType.Wall:
                edge.willReflect = false
                edge.willRefract = false
            case DeviceType.Emitter:
                edge.willReflect = false
                edge.willRefract = false
            default:
                fatalError("Device Type Not Defined")
            }
        }
    }
}
