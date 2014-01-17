require! \http
require! \url
require! \fs
require! \querystring
require! \request

json = JSON.parse fs.readFileSync \section.json,\utf-8
base = \http://landmaps.nlsc.gov.tw/S_Maps/qryTileMapIndex
gmap = \http://maps.google.com/maps/api/geocode/json?sensor=false&language=zh-tw&region=tw&address=
server = http.createServer (req, res) ->
  p = url.parse decodeURIComponent req.url
  q = querystring.parse p.query
  if q.address?
    # handling address
    addr = q.address.replace /台/g \臺

    # when have "路" , use google map api to get reverse query
    matches = /(..(?:市|縣))(.{1,3}(?:鄉|鎮|市|區))(.{2,8}路)(.*)/gi is addr
    if matches?
      uri = gmap+addr;
      error,response,body <- request {'url':uri, 'encoding':'utf-8', 'method': 'GET'}
      result = JSON.parse body
      result.source = uri
      res.writeHead 200, 'Content-Type': 'application/json'
      res.end JSON.stringify result
    # when only have "段", try to find landno
    else
      matches = /(..(?:市|縣))(.{1,2}(?:鄉|鎮|市|區))(.{2,8}段)(.*)/gi is addr
      uri = ''
      if matches?
        city-area = matches[1] + matches[2]
        if typeof json.area[city-area] != 'undefined'
          area-id = json.area[city-area]
          sec = matches[3]
          if typeof json.section[area-id][sec] != 'undefined'
            sec-id = json.section[area-id][sec].id
            matches[4] = matches[4].replace /之/,'-'
            num = matches[4] - /[^\d-]/g
            office = json.section[area-id][sec].o
            if num?
              if q.magic?
                query = "lands[]="+matches[1]+','+sec+','+num
                res.writeHead 200, 'Content-Type': 'text/plain'
                res.end query
              else
                query =
                  \flag : 2
                  \office : office
                  \sect : sec-id
                  \landno : num
                uri = base + \? + querystring.stringify query
                error,response,body <- request {'url':uri, 'encoding':'utf-8', 'method': 'GET'}
                result = JSON.parse body
                result.push 'source: '+uri
                res.writeHead 200, 'Content-Type': 'application/json'
                res.end JSON.stringify result
      else
        res.writeHead 404, 'Content-Type': 'text/html'
        res.end '{"error":"wrong format", "msg":"錯誤的地號格式，需縣市鄉鎮市區段號碼：[桃園縣蘆竹鄉內興段632]"}';
  else
    res.writeHead 404, 'Content-Type': 'text/plain'
    res.end '{"error":"wrong request", "msg":"錯誤的傳入參數，需帶入完整地址或完整地號[?address=臺北市信義區市府路1號]"}';

server.listen 9192
