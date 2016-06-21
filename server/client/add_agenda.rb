require 'rest_client'

ip = '13.71.157.250'
port = 2928

puts data = {
  title: '次回のMPCハッカソン開催について',
  subject: {
    ハッカソン開催の目的確認: 10,
    ハッカソンテーマ決定: 20,
    スケジュールドラフト作成: 50,
  },
  organizer: 'hattori',
  date: '2016/3/26',
  time: '10:00',
  place: '会議室A',
  member: {
    服部: 'hattori@thermos.com',
    三橋: 'mituhashi@thermos.com',
    秋月: 'akizuki@thermos.com',
    湯口: 'yuguti@thermos.com',
    大戸: 'ohto@thermos.com',
    村上: 'murakami@thermos.com',
  },
}.to_json
p RestClient.post("http://#{ip}:#{port}/create", data, content_type: :json)
