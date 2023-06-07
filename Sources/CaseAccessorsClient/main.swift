import CaseAccessors

@CaseAccessors @CaseConditionals enum TestEnum {
    case one(String)
    case two(Int)
    case three(String, Int)
}

let one = TestEnum.one("One")
let two = TestEnum.two(2)
let three = TestEnum.three("Three", 3)

print("one.one == \(String(describing: one.one))")
print("one.two == \(String(describing: one.two))")
print("one.three == \(String(describing: one.three))")
print("one.isOne == \(String(describing: one.isOne))")
print("one.isTwo == \(String(describing: one.isTwo))")
print("one.isThree == \(String(describing: one.isThree))")

print("two.one == \(String(describing: two.one))")
print("two.two == \(String(describing: two.two))")
print("two.three == \(String(describing: two.three))")
print("two.isOne == \(String(describing: two.isOne))")
print("two.isTwo == \(String(describing: two.isTwo))")
print("two.isThree == \(String(describing: two.isThree))")

print("three.one == \(String(describing: three.one))")
print("three.two == \(String(describing: three.two))")
print("three.three == \(String(describing: three.three))")
print("three.isOne == \(String(describing: three.isOne))")
print("three.isTwo == \(String(describing: three.isTwo))")
print("three.isThree == \(String(describing: three.isThree))")
