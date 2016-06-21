require 'rest_client'

ip = '13.71.157.250'
port = '2928'

puts data = [{
  contents: '担当エバンジェリストアサインを所長に依頼',
  location: [10,20],
  member: '村上',
  deadline: '3/29',
  todo: true,
},{
  contents: '過去の予算状況を確認',
  location: [30,40],
  member: '湯口',
  deadline: '3/30',
  todo: true,
},{
  contents: '平野さんレビュースケジュール確定',
  location: [50,60],
  member: '三橋',
  deadline: '3/31',
  todo: true,
}].to_json

id  = '2016/3/26/10/00/hattori'
url = "http://#{ip}:#{port}/page/#{id}/page_1"
p RestClient.post(url, data, content_type: :json)
