"use strict";

var Schema = function (schema)
{
  var entity;
  var Entity;

  for (entity in schema)
  {
    Entity = function (id, values)
    {
      var attribute;

      Object.defineProperty (this, "id", {
        enumerable: true,
        get: function () { return id; },
        set: function (value) { return id = value; }});

      for (attribute of schema[entity]) {
        (function(that, attribute) {
          Object.defineProperty (that, attribute, {
            enumerable: true,
            get: function () { return values[attribute]; },
            set: function (value) { return vaulues[attribute] = value; }});
        })(this, attribute);
      }
    };

    Object.defineProperty (this, entity, {
      enumerable: true,
      value: Entity});
  }
};


function data (query, success)
{
  return jQuery.ajax({
    'type': 'POST',
    'url': '/cgi-bin/eql?demo',
    encoding: 'UTF-8',
    'contentType': 'application/sql; charset=UTF-8',
    'data': query,
    'dataType': 'json',
    'success': success});
}
