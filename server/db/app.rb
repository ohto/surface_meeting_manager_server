# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require 'mongo'
require 'json'

enable :cross_origin
db = Mongo::Connection.new.db('web')

get '/*' do |dt|
  cross_origin
  if m = dt.match(/^([^\/])+\/(.+)\/?$/)
    db.collection(m[1]).find_one('_id': m[2]).to_json
  else {}.to_json
  end
end

post '/*' do |dt|
  cross_origin
  status = if m = dt.match(/^([^\/])+\/(.+)\/?$/)
    key = {'_id': m[2]}
    dt  = JSON.parse(request.body.read)
    wd  = db.collection(m[1])
    if wd.find(key).count == 0 then wd.save(key.merge dt)
    else wd.update(key, dt)
    end
    true
  else false
  end
  {status: status}.to_json
end
