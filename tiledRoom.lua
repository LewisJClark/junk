local assetManager = require("junk.assets.assetManager")
local entity = require("junk.entity")
local tilemapEntity = require("junk.tilemapEntity")
local room = require("junk.room")
local class = require("junk.third_party.middleclass")

local function _loadTileLayer(room, layer)
   room:createLayer(layer.name)
   local map = room:createEntity(tilemapEntity, layer.name, 0, 0, { 
      width = layer.width,
      height = layer.height,
      tileset = assetManager.tilesets[layer.properties.tileset]
   }).tilemap
   for y=1,layer.height do
      for x=1,layer.width do
         local i =  ((y - 1) * layer.width) + x
         map:set(x, y, layer.data[i])
      end
   end
end

local function _loadObjectLayer(room, layer)
   room:createLayer(layer.name)
   for _,e in ipairs(layer.objects) do
      local kind = e.properties.kind
      e.properties.kind = nil
      room:createEntity(kind, layer.name, e.x, e.y, e.properties)
   end
end

local function _loadGroupLayer(room, layer)
   for i,layer in ipairs(layer.layers) do
      if layer.type == "tilelayer" then _loadTileLayer(room, layer)
      elseif layer.type == "objectgroup" then _loadObjectLayer(room, layer)
      elseif layer.type == "group" then _loadGroupLayer(room, layer) end
   end
end

local tiledRoom = class("tiledRoom", room)

--[[
   A tiled room is just like a normal room apart from it will create layers and
   populate them based on a Tiled Map Editor export.
]]
function tiledRoom:initialize(name, filename)
   room.initialize(self, name)
   local room_data = require(filename)
   _loadGroupLayer(self, room_data)
end

return tiledRoom
