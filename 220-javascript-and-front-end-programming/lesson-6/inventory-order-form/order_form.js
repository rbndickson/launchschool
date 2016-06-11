var inventory;

(function() {
  inventory = {
    last_id: 0,
    collection: [],

    setDate: function() {
      $( "#order_date" ).html(this.dateString);
    },
    dateString: function() {
      return new Date().toUTCString();
    },
    cacheTemplate: function() {
      var $temp_template = $("#inventory_item").remove();
      // sets the item template to this.template
      this.template = $temp_template.html();
    },
    add: function() {
      this.last_id++;
      var item = {
        id: this.last_id,
        name: "",
        stock_number: "",
        quantity: 1
      };
      this.collection.push(item);

      return item;
    },
    newItem: function(e) {
      e.preventDefault();
      var item = this.add();
      var $item = $(this.template.replace(/ID/g, item.id));

      $( "#inventory" ).append($item);
    },
    // remove item from collection
    remove: function(idx) {
      console.log(idx);

      this.collection = this.collection.filter(function(item) {
        return item.id !== idx;
      });
    },
    get: function(id) {
      var found_item;
      this.collection.forEach(function(item) {
        if (item.id === id) {
          found_item = item;
          return false; // this is to stop the iteration
        }
      });
      return found_item;
    },
    update: function($item) {
      var id = this.findID($item);
      var item = this.get(id);

      item.name = $item.find( "[name^=item_name]" ).val();
      item.stock_number = $item.find( "[name^=item_stock_number]" ).val();
      item.quantity = $item.find( "[name^=item_quantity]" ).val();
    },
    // to avoid duplication
    findParent: function(e) {
      return $(e.target).closest( "tr" );
      // e.target is whatever element set off the event
    },
    findID: function($item) {
      return +$item.find("input[type=hidden]").val();
      // the + converts the result to an integer so the types are the same else
      // will be comparing an id string to an id integer
    },
    // delete item from the page
    deleteItem: function(e) {
      e.preventDefault();
      var $item = this.findParent(e).remove(); // remove from page

      this.remove(this.findID($item)); // remove from collection
    },
    updateItem: function(e) {
      var $item = this.findParent(e);

      this.update($item);
    },
    bindEvents: function() {
      $( "#add_item" ).on( "click", $.proxy(this.newItem, this)); // proxy to keep the context
      // this below uses delegation, the element to be deleted does not exist on the
      // initial page load so we must access it though the parent element (#inventory)
      // which does exist when the page is loaded.
      $( "#inventory" ).on( "click", "a.delete", $.proxy(this.deleteItem, this));
      // blur is when the user changes focus, so the item object can be updated
      // each change of focus
      $( "#inventory" ).on( "blur", ":input", $.proxy(this.updateItem, this));
    },
    init: function() {
      this.setDate();
      this.cacheTemplate();
      this.bindEvents();
    }
  };
})(); // this is an immediately invoked function - why use this?
      // it makes the variables within the function private.

$($.proxy(inventory.init, inventory));
// proxy is used to pass in the inventory context so that the context is the
// inventory rather than the window.
