/**
  Items Controller
*/

//3rd party modules
var express = require('express');
var mongoose = require('mongoose');
var winston = require('winston');

//own modules
var DefaultController = require('./');

var Item = mongoose.model('Item');
var defaultCtrl;

var Controller = function(){
  defaultCtrl = new DefaultController(Item, 'Item');
  
  // Define route params
  this.paramFormat = defaultCtrl.format();
  this.paramItem = defaultCtrl.modelParam();

  // Define handlers for rest calls
  this.find = defaultCtrl.find;
  this.create = customCreate;
  
  this.get = defaultCtrl.get;
  this.update = customUpdate;
  this.remove = customRemove; // Default one does not run pre-remove hook

  this.getImage = getImage;

  return this;
}

function customCreate(req, res) {
  var item = new Item(req.body);
  item.save( function(err){
    if(err) {
	  winston.error(err.message); 
	  return res.status(400).json({ error:err.message }); 
	}
        
    if(res){
      return res.status(200).json(item);
    }
  });  
}

function customUpdate(req, res) {
  // Handle requests that only provide available or in_stock in a special manner
  if (req.body.in_stock !== undefined && req.body.available === undefined) {
    handleUpdateInStock(req, res);
  }
  else if (req.body.in_stock === undefined && req.body.available !== undefined) {
	handleUpdateAvailable(req, res);
  }
  
  // Updating the item body
  for (var key in req.body) {
	req.Item[key] = req.body[key];
  }  
  
  // Regular save
  req.Item.save(function(err) {
	if (err) { 
	  winston.error(err.message);
	  return res.status(400).json({error:err.message}); 
	}
	else {
	  res.status(200).json(req.Loan); 
	}
  });
}

function handleUpdateInStock(req, res) {
  var delta_stock = req.body.in_stock - req.Item.in_stock;

  // Increase availability with the same amount that in_stock was changed
  winston.info('Received only in_stock in PUT, automatically modifying available with the same amount:' + delta_stock);
  req.body.available = req.Item.available + delta_stock;
}

function handleUpdateAvailable(req, res) {
  var delta_stock = req.body.available - req.Item.available;

  // Update in_stock in accordance with received delta in_stock
  winston.info('Received only available in PUT, automatically modifying in_stock with the same amount:' + delta_stock);
  req.body.in_stock = req.Item.in_stock + delta_stock;
}

function customRemove(req, res) {
  req.Item.remove(function(err) {
	if (err) {
	  winston.error(err.message);
	  return res.status(400).json(err);
	}
	res.status(200).json({});
  });
}

function getImage(req, res) {
  req.Item.fetchImageData(function(result) {
	if (result instanceof Error) return res.status(400).json(result.message);
    else {
	  //console.log('Image found, returning data : ' + JSON.stringify(result));
	  res.set('Content-Type', result.type);
	  res.send(result.data);
    } 
  });
}

module.exports = Controller;
