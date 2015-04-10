//
//  GOOverlapManager
//  Planck
//
//  Created by Wang Jinghan on 10/04/15.
//  Copyright (c) 2015 Echx. All rights reserved.
//

import UIKit

class GOOverlapManager: NSObject {
    
    //Calculate the projection
    private class func getProjectionOfShape(vertices: [CGPoint], onto vector: CGVector) -> (min: CGFloat, max: CGFloat){
        var minProj = CGFloat.max
        var maxProj = CGFloat.min
        var normalisedVector = vector.normalised
        
        for vertex in vertices {
            var proj = vertex.x * normalisedVector.dx + vertex.y * normalisedVector.dy
            maxProj = maxProj < proj ? proj : maxProj
            minProj = minProj > proj ? proj : minProj
        }
        return (minProj, maxProj)
    }
    
    //Applying SAT (Separating Axix Theorm) to check if two shape are intersect
    class func isShape(aVertices: [CGPoint], overlappedWith bVertices: [CGPoint]) -> Bool{
        for var i = 0; i < aVertices.count; i++ {
            let point1 = aVertices[i]
            let point2 = aVertices[(i + 1) % aVertices.count]
            
            //get the normal vector for every edge
            let normal = CGVectorMake(-(point2.y - point1.y), point2.x - point1.x)
            
            //calculate the projection on the normal vector
            let projectionOfShapeA = self.getProjectionOfShape(aVertices, onto: normal)
            let projectionOfShapeB = self.getProjectionOfShape(bVertices, onto: normal)
            
            //if the two project is not overlapped, the two shape is guaranteed not intersected
            if projectionOfShapeA.max < projectionOfShapeB.min || projectionOfShapeB.max < projectionOfShapeA.min {
                return false
            }
        }
        
        //check the normal vectors of edges of B
        for var i = 0; i < bVertices.count; i++ {
            let point1 = bVertices[i]
            let point2 = bVertices[(i + 1) % bVertices.count]
            let normal = CGVectorMake(-(point2.y - point1.y), point2.x - point1.x)
            let projectionOfShapeA = self.getProjectionOfShape(aVertices, onto: normal)
            let projectionOfShapeB = self.getProjectionOfShape(bVertices, onto: normal)
            
            if projectionOfShapeA.max < projectionOfShapeB.min || projectionOfShapeB.max < projectionOfShapeA.min {
                return false
            }
        }
        return true
    }
}
