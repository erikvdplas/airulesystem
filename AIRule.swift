//Copyright Erik van der Plas, 2015

import Foundation

class AIRule:NSObject {
    var predicate:NSPredicate?
    var assertingFact:String?
    var grade:Float?
    
    ///Initiate a rule with a predicate, an asserting fact and a grade with which the fact will be asserted. This grade can be negative too.
    init(predicate:NSPredicate, assertingFact fact:String, withGrade grade:Float) {
        
        super.init()
        self.predicate = predicate
        self.assertingFact = fact
        self.grade = grade
    }
}