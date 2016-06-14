//Copyright Erik van der Plas, 2015

import Foundation

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

extension NSPredicate {
    
    ///Evaluates predicate with just substitution variables and no object.
    func evaluateWithSubstitutionVariables(dictionary:[String : AnyObject]) -> Bool {
        
        return evaluateWithObject(nil, substitutionVariables: dictionary)
    }
    
    
    ///Checks wether predicate can be evaluated with a dictionary of substitution values. (IMPROVEMENT NEEDED)
    func canEvaluateWithSubstitutionVariables(dictionary:[String : AnyObject]) -> Bool {
        
        let components = self.predicateFormat.componentsSeparatedByString(" ")
        
        let requiredVariablesWithDollar = components.filter { $0.characters.first == "$" }
        
        let requiredVariables = requiredVariablesWithDollar.map { $0.substringFromIndex($0.startIndex.advancedBy(1)) }
        
        for requiredVariable in requiredVariables {
            if !dictionary.keys.contains(requiredVariable) {
                return false
            }
        }
        
        return true
    }
}

class AIRuleSystem:NSObject {
    
    ///Dictionary of facts that are concluded by the rule system after evaluation. Facts can also be used as input by rules in the system.
    var facts:Dictionary<String, Float> = [:]
    
    ///Dictionary of values that will be used as input for rules.
    var state:Dictionary<String, AnyObject> = [:]
    
    ///Array of rules.
    var rules:Array<AIRule> = [] {
        didSet {
            agenda = rules
        }
    }
    
    ///Array of rules that still have to be evaluated.
    var agenda:Array<AIRule> = []
    
    ///Array of rules that have been evaluated.
    var executed:Array<AIRule> = []
    
    ///Boolean value that specifies if another evaluation must be performed to ensure that all the rules can be evaluated with all the possible substitution values.
    private var moreEvaluations:Bool = false
    
    ///Method that adds rule to the rule system.
    func addRule(rule:AIRule) {
        rules.append(rule)
    }
    
    ///Method that adds an array of rules to the rule system.
    func addRules(rules:Array<AIRule>) {
        for rule in rules {
            addRule(rule)
        }
    }
    
    ///Resets agenda to all the rules in the rule system, clears the executed rules array and clears the facts. The state dictionary will be left unchanged.
    func reset() {
        agenda = rules
        executed = []
        facts = [:]
    }
    
    ///Evaluates all rules inside the agenda and asserts facts if needed.
    func evaluate() {
        for rule in agenda {
            evaluateRule(rule)
        }
        
        if moreEvaluations {
            moreEvaluations = false
            evaluate()
        }
    }
    
    ///Evaluates a rule and asserts a fact if needed.
    func evaluateRule(rule:AIRule) {
        
        guard let predicate = rule.predicate else {
            return
        }
        
        var substitutionVariables:Dictionary<String, AnyObject> = [:]
        substitutionVariables += state
        substitutionVariables += facts
        
        if predicate.canEvaluateWithSubstitutionVariables(substitutionVariables) {
            if predicate.evaluateWithSubstitutionVariables(substitutionVariables) {
                
                executeAssertionOfRule(rule)
            }
        }
    }
    
    ///Executes the assertion of a fact of a rule.
    func executeAssertionOfRule(rule:AIRule) {
        
        guard let factName = rule.assertingFact else {
            return
        }
        
        guard let grade = rule.grade else {
            return
        }
        
        if let _ = self.facts[factName] {
            self.facts[factName]! += grade
        } else {
            self.facts[factName] = grade
        }
        
        if agenda.contains(rule) {
            let index = agenda.indexOf(rule)
            agenda.removeAtIndex(index!)
        }
        
        executed.append(rule)
        
        moreEvaluations = true
    }
}