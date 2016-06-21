require 'rest_client'

ip   = '13.71.157.250'
port = 2928

id = '2016/3/26/10/00/hattori'
p url = "http://#{ip}:#{port}/page/#{id}/page_1"
p RestClient.get(url) # get by page

p url = "http://#{ip}:#{port}/page/#{id}/"
p RestClient.get(url) # get all

