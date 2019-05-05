#
# Googleの移動履歴をもとにしてある日付の位置履歴を見る
#
# 移動履歴はここから取得できる
#   https://takeout.google.com/
# ~/Downloads/Takeout/ロケーション履歴/ロケーション履歴.json というファイルを使う
#
# usage: % ruby dataloc.rb 2019/5/5 [2019/5/6]
#

require 'json'

exit unless ARGV[0] =~ /^(\d+)\/(\d+)\/(\d+)$/

from = Time.new($1,$2,$3)
to = from + 24 * 60 * 60

if ARGV[1].to_s =~ /^(\d+)\/(\d+)\/(\d+)$/
  to = Time.new($1,$2,$3) + 24 * 60 * 60
end

data = JSON.parse(File.read('ロケーション履歴.json'))
locations = data['locations']

def radian(degree)
  degree * Math::PI / 180
end

def distance(lat1,long1,lat2,long2)
  radLat1 = radian(lat1)
  radLon1 = radian(long1)
  radLat2 = radian(lat2)
  radLon2 = radian(long2)
  r = 6378137.0; # 赤道半径

  averageLat = (radLat1 - radLat2) / 2;
  averageLon = (radLon1 - radLon2) / 2;
  r * 2 * Math.asin(Math.sqrt(Math.sin(averageLat) ** 2 + Math.cos(radLat1) * Math.cos(radLat2) * Math.sin(averageLon) ** 2))
end

lastlat = 0
lastlong = 0
locations.each { |loc|
  t = Time.at(loc['timestampMs'].to_f / 1000)
  break if t >= to
  if t >= from
    lat = loc['latitudeE7'].to_f / 10000000.0
    long = loc['longitudeE7'].to_f / 10000000.0
    if loc['activity'] && loc['accuracy'] > 50 && distance(lastlat,lastlong,lat,long) > 50 # accuracyが小さいと結構いい加減な情報
      lastlat = lat
      lastlong = long
      latstr = (lat >= 0.0 ? "N#{lat}" : "S#{-lat}")
      longstr = (long >= 0.0 ? "E#{long}" : "W#{-long}")
      # puts loc['timestampMs']
      puts t
      # puts loc['accuracy']
      puts "[#{latstr},#{longstr},Z14]"
      puts ""
    end
  end
}




