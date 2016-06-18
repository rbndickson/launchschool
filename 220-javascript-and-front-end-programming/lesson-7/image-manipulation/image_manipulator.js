var canvas = document.createElement("canvas"),
    ctx = canvas.getContext("2d"),
    images = $( "img" );

var manipulator = {
  init: function() {
    for (var i = 0; i < images.length; i++) {
      $( ".col-right" ).append(this.createNewImage(images[i]));
    }
  },

  createNewImage: function(image) {
    var new_img = document.createElement("img");
    var image_data;

    this.setCanvasDimensions(image);
    this.setCanvasStyles(image);

    ctx.drawImage(image, 0, 0);
    image_data = ctx.getImageData(0, 0, image.naturalWidth, image.naturalHeight);

    for (var i = 0; i < image_data.data.length; i += 4) {
      var red = image_data.data[i],
          green = image_data.data[i + 1],
          blue = image_data.data[i + 2],
          grey_value = this.rgbToGreyValue(red, green, blue);

      image_data.data[i] = image_data.data[i + 1] = image_data.data[i + 2] = grey_value;
    }

    ctx.putImageData(image_data, 0, 0);
    new_img.src = canvas.toDataURL();
    return new_img;
  },

  rgbToGreyValue: function(r, g, b) {
    return (r * 0.3086 + g * 0.6094 + b * 0.0820);
  },

  setCanvasDimensions: function(image) {
    canvas.width = image.naturalWidth;
    canvas.height = image.naturalHeight;
  },

  setCanvasStyles: function(image) {
    canvas.style.width = image.width + "px";
    canvas.style.height = image.height + "px";
  }
};

manipulator.init();
