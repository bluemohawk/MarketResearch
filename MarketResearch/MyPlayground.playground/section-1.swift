// Playground - noun: a place where people can play

import UIKit


var myColor:UIColor =  UIColor.blueColor()
var myButton:UIButton = UIButton(frame: CGRectMake(10, 20, 150, 100))
myButton.backgroundColor = myColor

func sayHello(name:String)->String {
    return "Hello \(name)"

}

sayHello("Francois")


func sumOf(numbers:Int ...)->Int {
    var sum:Int = 0
    
    for number in numbers {
        sum += number
        
    }
    return sum
}

sumOf(1,2,3,4,5,6,7,8,900)

sayHello("big boy")
sumOf(1,2,4,8,9,45,8)


class Shape{
    var numberOfSides:Int = 0
    var name: String
    init(name:String){
        self.name = name
    }
    
    func myName(name:String)->String{
        return "My name is \(name)"
    }
    func simpleDescription()->String{
        return "A shape with \(numberOfSides) sides and my name is \(name)"
    }
}

var aShape = Shape(name: "lapin")
aShape.simpleDescription()
aShape.myName("jojo")





class Square: Shape {
    var sideLenght:Double
    
    init(sideLenght:Double, name:String){
        self.sideLenght = sideLenght
        super.init(name: name)
        numberOfSides = 4
    }
    
    func area()->Double{
        return sideLenght * sideLenght
    }
    
    override func simpleDescription() -> String {
        return "A square with sides of leght \(sideLenght)"
    }
}


var test:Square = Square(sideLenght: 20, name: "test")
test.simpleDescription()
test.area()



class EquilateralTriangle:Shape {
    var sideLenght:Double = 0.0
    init(sideLenght: Double, name: String) {
        self.sideLenght = sideLenght
        super.init(name: name)
        numberOfSides = 3
        
    }
    
    var perimeter:Double{
        get{
            return 3.0 * sideLenght
        }
        set{
            sideLenght = newValue/3.0
        }
    }
    
    override func simpleDescription() -> String {
        return "An equilateral triangle with sides of lenght \(sideLenght)"
    }
}

var testTriange:EquilateralTriangle = EquilateralTriangle(sideLenght: 2.0, name: "triangle")
testTriange.perimeter
testTriange.perimeter = 15.0
testTriange.sideLenght
testTriange.sideLenght = 30.0
testTriange.perimeter



var unExample = EquilateralTriangle(sideLenght: 10.0, name: "boubou")
unExample.perimeter
unExample.simpleDescription()

let firstString:String
1String = "Lapin"

let secondString:String
2String = "est bleu"


let thirdString = (firstString) + (secondString)

print(thirdString)



