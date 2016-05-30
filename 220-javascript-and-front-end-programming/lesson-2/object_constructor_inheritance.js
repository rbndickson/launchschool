// this means we can create a new Vehicle without using the new keyword.
function Vehicle() {
  // instanceof is an operator
  if (!(this instanceof Vehicle)) {
    return new Vehicle();
  }
  return this;
}

Vehicle.prototype.doors = 4;
Vehicle.prototype.wheels = 4;

var sedan = new Vehicle();
var coupe = new Vehicle();
coupe.doors = 2;
console.log(coupe.doors); // 2

console.log(sedan.hasOwnProperty("doors")); // false as inherited
console.log(coupe.hasOwnProperty("doors")); // true

function Coupe() {
  if (!(this instanceof Coupe)) {
    return new Coupe();
  }
  return this;
}

Coupe.prototype = new Vehicle();
Coupe.prototype.doors = 2;

var coupe_2 = new Coupe();
console.log(coupe_2 instanceof Vehicle); // true
console.log(coupe_2 instanceof Coupe); // true
// so instances can be instances of multiple objects

function Motorcycle() {
  // needs to be set to local var as properties are being modified internally
  var o = this;
  if (!(o instanceof Motorcycle)) {
    return new Motorcycle();
  }
  o.doors = 0;
  o.wheels = 0;
  return o;
}

Motorcycle.prototype = new Vehicle();
Motorcycle.prototype = new Vehicle();

function Sedan() {
}
Sedan.prototype = Object.create(Vehicle());
var sedan = new Sedan();

console.log(coupe_2 instanceof Vehicle); // true
console.log(coupe_2 instanceof Sedan); // true

// An extra way to create an object from a constructor using inheritance.

Sedan.prototype = Object.create(Vehicle.prototype);
var sedan_2 = new Sedan();
console.log(sedan_2 instanceof Vehicle); // true
console.log(sedan_2 instanceof Sedan); // true

// Object.create can also create singleton objects (objects created with an
// object literal)
var prototype_car = {
  doors: 5,
  wheels: 3
};

// this creates a different object
var ceo_car = Object.create(prototype_car);

ceo_car.doors = 7;

// so these will be different
console.log(ceo_car.doors); // 5
console.log(prototype_car.doors);// 7
