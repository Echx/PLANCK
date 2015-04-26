//
//  GOGrid.swift
//  GridOptic
//
//  Created by Wang Jinghan on 30/03/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

// GOGridDelegate methods are triggered when new critical point is generated
protocol GOGridDelegate {
    func grid(grid: GOGrid, didProduceNewCriticalPoint point: CGPoint,
        onEdge edge: GOSegment?, forRayWithTag tag: String)
    func gridDidFinishCalculation(grid: GOGrid, forRayWithTag tag: String)
}

// GOGrid is the main playground for this library, every instrument should be 
// appended to the instrument list of the grid and the displaying of each
// instrument is supported by this class
// GOGrid is responsible to most of the calculation of this optic library and 
// it also keeps track of the geometric information of each instrument lcated
// within the grid
class GOGrid: NSObject, NSCoding {
    let unitLength: CGFloat
    let width: NSInteger
    let height: NSInteger
    let origin: CGPoint = CGPointZero
    let backgroundRefractionIndex: CGFloat = GOConstant.vacuumRefractionIndex
    let unitDegree = GridDefaults.unitDegree
    
    var instruments = [String: GOOpticRep]()
    var delegate: GOGridDelegate?
    var refractionEdgeParentStack = GOStack<String>()
    var queue = dispatch_queue_create(GridDefaults.calculationQueueIdentifier,
        DISPATCH_QUEUE_SERIAL)
    var shouldContinueCalculation: Bool = false
    
    var size: CGSize {
        // returns the size of the grid, in square CGFloat
        get {
            return CGSizeMake(CGFloat(self.width) * self.unitLength,
                CGFloat(self.height) * self.unitLength)
        }
    }
    
    var transformToDisplay: CGAffineTransform {
        // transformation to display grid (CGPoint representation)
        get {
            return CGAffineTransformMakeScale(self.unitLength, self.unitLength)
        }
    }
    
    var transformToGrid: CGAffineTransform {
        // transformation to display grid (CGPoint representation)
        get {
            return CGAffineTransformMakeScale(1 / self.unitLength,
                1 / self.unitLength)
        }
    }
    
    var boundaries : [GOSegment] {
        // the boundaries of the grid represented by four line segments
        get {
            var boundaries = [GOLineSegment]()
            
            let bottomBound = GOLineSegment(
                center: CGPoint(x: origin.x + CGFloat(width / 2),
                y: origin.y - GOConstant.boundaryOffset),
                length: CGFloat(width) + GOConstant.boundaryExtend,
                direction: CGVector(dx: 1, dy: 0)
            )
            let upperBound = GOLineSegment(
                center: CGPoint(x: origin.x + CGFloat(width / 2),
                y: origin.y + CGFloat(height) + GOConstant.boundaryOffset),
                length: CGFloat(width) + GOConstant.boundaryExtend,
                direction: CGVector(dx: 1, dy: 0)
            )
            let leftBound = GOLineSegment(
                center: CGPoint(x: origin.x - GOConstant.boundaryOffset,
                y: origin.y + CGFloat(height / 2)),
                length: CGFloat(height) + GOConstant.boundaryExtend,
                direction: CGVector(dx: 0, dy: 1)
            )
            let rightBound = GOLineSegment(
                center: CGPoint(x: origin.x + CGFloat(width) + GOConstant.boundaryOffset,
                y: origin.y + CGFloat(height / 2)),
                length: CGFloat(height) + GOConstant.boundaryExtend,
                direction: CGVector(dx: 0, dy: 1)
            )
            
            boundaries.append(bottomBound)
            boundaries.append(upperBound)
            boundaries.append(leftBound)
            boundaries.append(rightBound)

            return boundaries
        }
    }
    
    init(width: NSInteger, height: NSInteger, andUnitLength unitLength: CGFloat) {
        self.width = width
        self.height = height
        self.unitLength = unitLength
        super.init()
    }
    
    init(coordinate: GOCoordinate, andUnitLength unitLength: CGFloat) {
        self.width = coordinate.x
        self.height = coordinate.y
        self.unitLength = unitLength
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let unitLength = aDecoder.decodeObjectForKey(GOCodingKey.grid_unitLength) as CGFloat
        let width = aDecoder.decodeObjectForKey(GOCodingKey.grid_width) as NSInteger
        let height = aDecoder.decodeObjectForKey(GOCodingKey.grid_height) as NSInteger
        self.init(width: width, height: height, andUnitLength: unitLength)
        self.instruments = aDecoder.decodeObjectForKey(GOCodingKey.grid_instruments) as [String : GOOpticRep]
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(unitLength, forKey: GOCodingKey.grid_unitLength)
        aCoder.encodeObject(width, forKey: GOCodingKey.grid_width)
        aCoder.encodeObject(height, forKey: GOCodingKey.grid_height)
        
        aCoder.encodeObject(instruments, forKey: GOCodingKey.grid_instruments)
    }
    
    func clearInstruments() {
        // clear all the instruments in the grid
        self.instruments = [String: GOOpticRep]()
    }
    
    func addInstrument(instrument: GOOpticRep) -> Bool{
        // add one instrument into the instrument list
        if self.instruments[instrument.id] == nil {
            self.instruments[instrument.id] = instrument
            return true
        } else {
            // instrument already exists
            return false
        }
    }
    
    func isInstrumentOverlappedWidthOthers(instrument: GOOpticRep) -> Bool {
        // check whether an instrument is overlapped with others
        let instrumentVertices = instrument.vertices
        for (key, otherInstrument) in self.instruments {
            if instrument != otherInstrument {
                // iterate through instrument list
                let otherInstrumentVertices = otherInstrument.vertices
                if GOOverlapManager.isShape(instrumentVertices,
                    overlappedWith: otherInstrumentVertices) {
                    return true
                }
            }
        }
        return false
    }
    
    func getInstrumentDisplayPathForID(id: String) -> UIBezierPath? {
        if let instrument = self.getInstrumentForID(id) {
            let bezierPath = instrument.bezierPath.copy() as UIBezierPath
            bezierPath.applyTransform(self.transformToDisplay)
            return bezierPath
        } else {
            return nil
        }
    }
    
    func getRefractionIndexForID(id: String) -> CGFloat? {
        return self.instruments[id]?.refractionIndex
    }
    
    func getInstrumentForID(id: String) -> GOOpticRep? {
        return self.instruments[id]
    }
    
    func removeInstrumentForID(id: String) {
        self.instruments[id] = nil
    }
    
    func getCenterForGridCell(coordinate: GOCoordinate) -> CGPoint {
        // get the center point of the grid
        return CGPointMake(origin.x + CGFloat(coordinate.x) * self.unitLength,
                           origin.y + CGFloat(coordinate.y) * self.unitLength)
    }
    
    func getGridCoordinateForPoint(point: CGPoint) -> GOCoordinate {
        // convert CGPoint to GOCoordinate
        var x = round(point.x / self.unitLength)
        var y = round(point.y / self.unitLength)
        return GOCoordinate(x: Int(x), y: Int(y))
    }
    
    func getPointForGridCoordinate(coordinate: GOCoordinate) -> CGPoint {
        // convert GOCoordinate to CGPoint
        var x = CGFloat(coordinate.x) * self.unitLength
        var y = CGFloat(coordinate.y) * self.unitLength
        return CGPoint(x: x, y: y)
    }
    
    func getDisplayPointForGridPoint(point: CGPoint) -> CGPoint {
        return CGPointApplyAffineTransform(point, self.transformToDisplay)
    }
    
    func getGridPointForDisplayPoint(point: CGPoint) -> CGPoint {
        return CGPointApplyAffineTransform(point, self.transformToGrid)
    }
    
    func getInstrumentAtPoint(displayPoint: CGPoint) -> GOOpticRep? {
        let gridPoint = self.getGridPointForDisplayPoint(displayPoint)
        return getInstrumentAtGridPoint(gridPoint)
    }
    
    func getInstrumentAtGridPoint(gridPoint: CGPoint) -> GOOpticRep? {
        for (id, instrument) in self.instruments {
            if instrument.containsPoint(gridPoint) {
                return instrument
            }
        }
        return nil
    }
    
    //the ray is in the grid coordinate system
    func getRayPath(ray: GORay) -> GOPath {
        var path = UIBezierPath()
        path.moveToPoint(ray.startPoint)
        let criticalPoints = self.getRayPathCriticalPoints(ray)
        var points = [CGPoint]()
        
        // generate ray path according the critical points
        for point in criticalPoints {
            path.addLineToPoint(point)
            points.append(point)
        }
        path.applyTransform(self.transformToDisplay)
        
        return GOPath(bezierPath: path, criticalPoints: points)
    }
    
    func stopSubsequentCalculation() {
        self.shouldContinueCalculation = false
    }

    func startCriticalPointsCalculationWithRay(ray: GORay, withTag tag: String) {
        self.shouldContinueCalculation = true
        dispatch_async(self.queue, {
            self.refractionEdgeParentStack = GOStack<String>()
            var criticalPoints = [CGPoint]()
            
            // first add the start point of the ray
            criticalPoints.append(ray.startPoint)
            self.delegate?.grid(self, didProduceNewCriticalPoint:
                self.getDisplayPointForGridPoint(ray.startPoint),
                onEdge: nil, forRayWithTag: tag)
            
            // from the given ray, we found out each nearest edge
            // loop through each resulted ray until we get nil result (no intersection anymore)
            var edge = self.getNearestEdgeOnDirection(ray)
            var currentRay : GORay = ray
            // mark if the final ray will end at the boundary
            var willEndAtBoundary = true
            while (edge != nil) {
                if !self.shouldContinueCalculation {
                    return
                }
                // it must hit the edge, add the intersection point
                let newPoint = edge!.getIntersectionPoint(currentRay)!
                criticalPoints.append(newPoint)
                self.delegate?.grid(self, didProduceNewCriticalPoint:
                    self.getDisplayPointForGridPoint(newPoint),
                    onEdge: edge, forRayWithTag: tag)
                
                
                if let outcomeRay = self.getOutcomeRay(currentRay, edge: edge!) {
                    edge = self.getNearestEdgeOnDirection(outcomeRay)
                    currentRay = outcomeRay
                } else {
                    // no outcome ray, hit wall
                    willEndAtBoundary = false
                    break
                }
            }
            
            if willEndAtBoundary {
                // found out the intersection with the boundary
                // we treat boundary as 4 line segments
                if let finalPoint = self.getIntersectionWithBoundary(ray: currentRay) {
                    self.delegate?.grid(self, didProduceNewCriticalPoint:
                        self.getDisplayPointForGridPoint(finalPoint), onEdge: nil, forRayWithTag: tag)
                } else {
                    fatalError("something goes wrong no final point")
                }
            }
            
            self.delegate?.gridDidFinishCalculation(self, forRayWithTag: tag)
        })
    }
    
    // given a ray to start, this method will return every critical point of the path
    // (i.e. the contact points between light paths and instruments)
    func getRayPathCriticalPoints(ray: GORay) -> [CGPoint] {
        self.refractionEdgeParentStack = GOStack<String>()
        var criticalPoints = [CGPoint]()
        
        // first add the start point of the ray
        criticalPoints.append(ray.startPoint)
        
        // from the given ray, we found out each nearest edge
        // loop through each resulted ray until we get nil result (no intersection anymore)
        var edge = getNearestEdgeOnDirection(ray)
        var currentRay : GORay = ray
        // mark if the final ray will end at the boundary
        var willEndAtBoundary = true
        while (edge != nil) {
            // it must hit the edge, add the intersection point
            let newPoint = edge!.getIntersectionPoint(currentRay)!
            criticalPoints.append(newPoint)
            
            if let outcomeRay = getOutcomeRay(currentRay, edge: edge!) {
                edge = getNearestEdgeOnDirection(outcomeRay)
                currentRay = outcomeRay
            } else {
                // no outcome ray, hit wall or planck
                willEndAtBoundary = false
                break
            }
        }
        
        if willEndAtBoundary {
            // found out the intersection with the boundary
            // we treat boundary as 4 line segments
            if let finalPoint = getIntersectionWithBoundary(ray: currentRay) {
                criticalPoints.append(finalPoint)
            } else {
                fatalError("something goes wrong no final point")
            }
        }
        return criticalPoints
    }
    
    //given a ray and an edge, get the reflect/refract outcome, nil if there is no reflect/refract outcome
    func getOutcomeRay(ray: GORay, edge: GOSegment) -> GORay? {
        var indexIn: CGFloat = self.backgroundRefractionIndex
        var indexOut: CGFloat = self.backgroundRefractionIndex
        if edge.willRefract {
            if self.refractionEdgeParentStack.peek() == edge.parent {
                indexIn = self.getRefractionIndexForID(self.refractionEdgeParentStack.pop()!)!
                if let nextInstrument = self.refractionEdgeParentStack.peek() {
                    indexOut = self.getRefractionIndexForID(nextInstrument)!
                } else {
                    indexOut = self.backgroundRefractionIndex
                }
            } else {
                if let previousInstrument = self.refractionEdgeParentStack.peek() {
                    indexIn = self.getRefractionIndexForID(previousInstrument)!
                } else {
                    indexIn = self.backgroundRefractionIndex
                }
                indexOut = self.getRefractionIndexForID(edge.parent)!
                self.refractionEdgeParentStack.push(edge.parent)
            }
        }
        
        if let outcomeRay = edge.getOutcomeRay(rayIn: ray, indexIn: indexIn, indexOut: indexOut) {
            if outcomeRay.1 {
                // the outcome ray is caused by total reflection
                // push back the parent edge
                self.refractionEdgeParentStack.push(edge.parent)
            }
            return outcomeRay.0
        } else {
            return nil
        }
    }
    
    //given a ray to start, return nearest edge on the ray's path, nil if no edge lies on the path
    func getNearestEdgeOnDirection(ray: GORay) -> GOSegment? {
        // first retrieve back the edges on ray's path(if any)
        var edges = self.getEdgesOnDirection(ray)
        
        // if no edge on the ray path, return nil
        if edges.isEmpty {
           return nil
        }
        
        // get each intersection point with the edge
        // calculate its distance with the origin of the ray
        // find out the minimum one and return
        var minEdge = edges.first!
        var minDistance : CGFloat = CGFloat.max
        for edge in edges {
            var intersectPoint = edge.getIntersectionPoint(ray)!
            let distance = ray.startPoint.getDistanceToPoint(intersectPoint)
            // if current point is nearer, set the result edge be it
            if distance < minDistance {
                minDistance = distance
                minEdge = edge
            }
        }
        
        return minEdge
    }
    
    //given a ray to start, return all edges on the rays path
    func getEdgesOnDirection(ray: GORay) -> [GOSegment] {
        var edges = [GOSegment]()
        
        for (name, item) in self.instruments {
            // iterate through each instrument, and check if the ray is
            // intersect with the edges of the instruments
            let currentEdges = item.edges
            for edge in currentEdges {
                // check if this edge is intersected with the ray
                if edge.isIntersectedWithRay(ray) {
                    edges.append(edge)
                }
            }
        }
        
        return edges
    }
    
    func getAllEdges() -> [GOSegment]? {
        // firstly add all boundaries
        var output = self.boundaries
        
        // if it has instruments, add it to edge
        if (!self.instruments.isEmpty) {
            for (name, item) in self.instruments {
                let currentEdges = item.edges
                for edge in currentEdges {
                        output.append(edge)
                }
            }
        }
        
        return output
    }
    
    func deepCopy() -> GOGrid {
        return NSKeyedUnarchiver.unarchiveObjectWithData(NSKeyedArchiver.archivedDataWithRootObject(self)) as GOGrid
    }
    
    private func getIntersectionWithBoundary(#ray:GORay) -> CGPoint? {
        for bound in boundaries {
            if let point = bound.getIntersectionPoint(ray) {
                // check the point is in the visible space
                // heigh: [0, height]
                // width: [0, width]
                if point.x >= (-GOConstant.boundaryOffset) &&
                    point.x <= CGFloat(width) + GOConstant.boundaryOffset &&
                    point.y >= (-GOConstant.boundaryOffset) &&
                    point.y <= CGFloat(height) + GOConstant.boundaryOffset {
                        return point
                }
            }
        }
        
        return nil
    }
}
