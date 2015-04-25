//
//  GOOpticRep.swift
//  GridOptic
//
//  Created by Jiang Sheng on 1/4/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOOpticRep: NSObject, NSCoding {
    private var id: String
    var center: GOCoordinate
    var edges = [GOSegment]()
    var type = DeviceType.Mirror
    var direction: CGVector = OpticRepDefaults.defaultDirection
    var refractionIndex : CGFloat = GOConstant.vacuumRefractionIndex
    
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
    
    var vertices: [CGPoint] {
        get {
            fatalError("The computational variable vertices must be overriden by subclasses")
        }
    }
    
    init(id: String, center: GOCoordinate) {
        self.id = id
        self.center = center
        super.init()
    }
    
    init(refractionIndex: CGFloat, id: String, center: GOCoordinate) {
        self.id = id
        self.refractionIndex = refractionIndex
        self.center = center
        super.init()
        self.updateEdgesParent()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey(GOCodingKey.optic_id) as String
        let edges = aDecoder.decodeObjectForKey(GOCodingKey.optic_edges) as [GOSegment]
        let typeRaw = aDecoder.decodeObjectForKey(GOCodingKey.optic_type) as Int
        let type = DeviceType(rawValue: typeRaw)
        let center = aDecoder.decodeObjectForKey(GOCodingKey.optic_center) as GOCoordinate
        
        let refIndex = aDecoder.decodeObjectForKey(GOCodingKey.optic_refractionIndex) as CGFloat
        
        self.init(refractionIndex: refIndex, id: id, center: center)
        self.type = type!
        self.edges = edges
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: GOCodingKey.optic_id)
        aCoder.encodeObject(edges, forKey: GOCodingKey.optic_edges)
        aCoder.encodeObject(type.rawValue, forKey: GOCodingKey.optic_type)
        aCoder.encodeObject(center, forKey: GOCodingKey.optic_center)
        
        aCoder.encodeObject(refractionIndex, forKey: GOCodingKey.optic_refractionIndex)
    }
    
    // public method
    func refresh() {
        let direction = self.direction
        self.direction = OpticRepDefaults.defaultDirection
        self.setUpEdges()
        self.setDirection(direction)
        self.updateEdgesParent()
        self.updateEdgesType()
    }
    
    func containsPoint(point: CGPoint) -> Bool {
        var framePath = UIBezierPath()
        let vertices = self.vertices
        framePath.moveToPoint(vertices[0])
        
        for var i = 1; i < vertices.count; i++ {
            var vertex = vertices[i]
            framePath.addLineToPoint(vertex)
        }
        
        framePath.closePath()
        
        return framePath.containsPoint(point)
    }
    
    func setUpEdges() {
        fatalError("setUpEdges must be overridden by child classes")
    }
    
    func setDirection(direction: CGVector) {
        fatalError("setDirection must be overridden by child classes")
    }
    
    // private method
    private func setCenter(center: GOCoordinate) {
        self.center = center
        self.refresh()
    }
    
    private func setDeviceType(type: DeviceType) {
        self.type = type
        self.updateEdgesType()
    }
    
    private func updateEdgesParent() {
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
