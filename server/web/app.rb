# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/reloader'
require 'sinatra/cross_origin'
require 'fileutils'
require 'mongo'
require 'json'
require 'erb'
require 'pp'

enable :cross_origin
HOST = '13.71.157.250'
PORT = 2928
db = Mongo::Connection.new.db('web2')

def _send_mail(mail, title, body)
#  puts "to:#{mail}, title:#{title}, body:#{body}"
end

get '/page/*' do |dt|
  cross_origin
  wd = db.collection('wd')
  if dt.match(/\/$/)
    wd.find_one('_id': dt.sub(/\/$/,'')).to_json
  else
    m = dt.match(/^(.+)\/([^\/]+)$/)
    wd.find_one('_id': m[1])[m[2]].to_json
  end
end


post '/page/*', provides: :json do |dt|
  cross_origin
  status = if m = dt.match(/^(.+)\/([^\/]+)(\/)?$/)
    key = {'_id': m[1]}
    dt  = {m[2] => JSON.parse(request.body.read)}
    wd  = db.collection('wd')
    if wd.find(key).count == 0
      wd.save(key.merge dt)
    else wd.update(key, dt)
    end
    true
  else false
  end
  {status: status}.to_json
end


get '/front/*' do |id|
  cross_origin
  key = {'_id': id.sub(/\/$/,'')}
  db.collection('meeting').find_one(key)['front']
end


get '/confirm/*' do |id|
  cross_origin
  key = {'_id': id.sub(/\/$/,'')}
  @meeting = db.collection('meeting').find_one(key)
  @todo = []
  db.collection('wd').find_one(key).each do |k, v|
    v.is_a?(Array) and v.each{ |i| i['todo'] and @todo.push(i) }
  end
  erb :confirm
end


post '/report/*' do |id|
  cross_origin
  key = {'_id': id.sub(/\/$/,'')}
  @meeting = db.collection('meeting').find_one(key)
  @todo = []
  db.collection('wd').find_one(key).each do |k, v|
    v.is_a?(Array) and v.each{ |i| i['todo'] and @todo.push(i) }
  end
  body = erb(:report, locals: {
    header: request.body.read.match(/^header=(.*)$/)[1]
  })
  @meeting['member'].each_value{ |mail| _send_mail(mail, '議事録', body) }
  "下記の内容で議事録を送付しました<hr>#{body}<hr>"
end


post '/create', provides: :json do
  cross_origin
  @meeting = JSON.parse(request.body.read)
  %w(subject attendee).each do |t|
    (d = @meeting[t]).is_a?(String) and @meeting[t] = [d]
  end
  id = File.join(
    @meeting['date'],
    @meeting['time'].sub(':','/'),
    @meeting['organizer']
  )
  url = "http://#{HOST}:#{PORT}"
  key = {'_id': id}
  @meeting['front'] = erb(:front, locals: {
    url: File.join(url, 'meeting', id),
  })
  meeting = db.collection('meeting')
  if meeting.find(key).count == 0
    meeting.save(key.merge @meeting)
  else meeting.update(key, '$set': @meeting)
  end
  {status: true, url: File.join(url, 'front', id)}.to_json
end

