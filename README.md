# AIRuleSystem: the backwards compatible version of GKRuleSystem
----------------------------------------------------------------
## Usage
Since AIRuleSystem is almost the same as GKRuleSystem you can [check out the documentation for GKRuleSystem](https://developer.apple.com/library/ios/documentation/General/Conceptual/GameplayKit_Guide/RuleSystems.html) and you should be good to go. Here is a little example:
```let system = AIRuleSystem()

let predicate = NSPredicate(format: "$complexity <= 5")
let rule = AIRule(predicate: predicate, assertingFact: "ease", withGrade: 1.0)

system.addRule(rule)
system.state = ["complexity": 3]

system.evaluate()
print(system.facts)```

Of course you could get the same result with one simple if-statement, but if you add more rules you can do way more complex operations without getting unreadable code.

## License
This code is licenced under 'MIT License'.