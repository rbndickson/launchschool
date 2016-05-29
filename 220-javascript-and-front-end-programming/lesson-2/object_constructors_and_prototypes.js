// Object creation using Object constructor

var invoices = new Object();
invoices.foo = 130;
invoices.bar = 250;

// Object creation using string literal

var payments = {
  foo: 80,
  bar: 55
};

var payments_received = 0;
invoices.foo -= payments.foo;
invoices.bar -= payments.bar;

payments_received += (payments.foo + payments.bar);
console.log(payments_received);

var remaining_due = 0;
for (var client in invoices) {
  remaining_due += invoices[client];
}
console.log(remaining_due);

var second_invoices = Object.create(invoices);
invoices.foo = 0;
console.log(second_invoices.foo);

var Invoices = {
  foo: 130,
  bar: 250
};

var outstanding_invoices = [];
outstanding_invoices.push(Object.create(Invoices));
outstanding_invoices.push(Object.create(Invoices));

// Use freeze to make sure that the properties cannot accidentally be
// changed.

Object.freeze(Invoices);
console.log(Invoices.foo);
Invoices.foo = 0;
console.log(Invoices.foo); // Still returns 130

// But this means the properties are frozen on instances of invoice such as
// in our outstanding invoices
outstanding_invoices[0].foo = 0;
console.log(outstanding_invoices[0].foo);
// Even though the invoices in the outstanding_invoices are not frozen:
console.log(Object.isFrozen(Invoices)); // true
console.log(Object.isFrozen(outstanding_invoices[0])); // false
// the foo property points back to the Invoices object.

// To fix this we create a new function with foo and bar and the original
// properties:
function newInvoices() {
  return {
    foo: 130,
    bar: 250
  };
}
// and create the outstanding_invoices as before:
var outstanding_invoices = [];
outstanding_invoices.push(newInvoices());
outstanding_invoices.push(newInvoices());
// now new invoices can be created and the properties changed without affecting
// the existing invoices:
outstanding_invoices[0].foo = 0;
console.log(outstanding_invoices[0].foo);
console.log(outstanding_invoices[1].foo);

// Change newInvoices so invoice amounts can be passed in or defaults will be
// used. Also add getTotal function to return the total of foo and bar.

function newInvoices(clients) {
  clients = clients || {};
  var invoices = {
    foo: clients.foo || 130,
    bar: clients.bar || 250
  };
  invoices.getTotal = function() {
    return invoices.foo + invoices.bar;
  };
  return invoices;
}
outstanding_invoices.push(newInvoices());
console.log(outstanding_invoices[2].getTotal());
