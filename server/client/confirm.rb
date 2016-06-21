require 'rest_client'

ip = '13.71.157.250'
port = 2928

id  = '2016/3/26/10/00/hattori'
url = "http://#{ip}:#{port}/confirm/#{id}"
p RestClient.get(url)
