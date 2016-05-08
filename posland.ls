require! <[ http url fs querystring request ]>

json = JSON.parse fs.readFileSync \section.json,\utf-8
base = \http://landmaps.nlsc.gov.tw/S_Maps/qryTileMapIndex
gmap = \http://maps.google.com/maps/api/geocode/json?sensor=false&language=zh-tw&region=tw&address=
cors =
  'Access-Control-Allow-Origin': \*
  'Access-Control-Allow-Headers': 'X-Requested-With,Content-Type,If-Modified-Since'
  'Access-Control-Allow-Methods': 'GET,POST,PUT'

strReplace = (search, replace, subject) ->
  i = 0
  for x in search
    subject = subject.replace x replace[i]
    i++
  return subject
toNum = (str) ->
  return str_replace(['１','２','３','４','５','６','７','８','９','０'], [1,2,3,4,5,6,7,8,9,0], str);

server = http.createServer (req, res) ->
  if req.method is \OPTIONS
    res.writeHead 204, cors; res.end!; return

  p = url.parse decodeURIComponent req.url
  q = querystring.parse p.query
  console.log 123
  if q.address? || q.landno?
    # address
    if q.address?
      addr = q.address.replace /台/g \臺
      # tokenize address
      matches = /(..[市縣])(.{1,2}[^鄉鎮市區]?[鄉鎮市區])(.{1,3}[村里])?(.{1,4}鄰)?(.{1,3}[街路])?(.{1,2}段)?(.{1,2}巷)?(.{1,2}弄)?(.*)/gi is addr;
      console.log matches
      addr = encodeURIComponent(addr)
      # TODO to pass token to http://maps.nlsc.gov.tw/
      uri = gmap+addr;
      error,response,body <- request {'url':uri, 'encoding':'utf-8', 'method': 'GET'}
      result = JSON.parse body
      result.source = uri
      res.writeHead 200, {'Content-Type': 'application/json'} <<< cors
      res.end JSON.stringify result

    # landno
    else if q.landno?
      addr = q.landno.replace /台/g \臺
      matches = /(..(?:市|縣))(.{1,3}(?:鄉|鎮|市|區))(\D{2,}段)(.*)/gi is addr
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
                res.writeHead 200, {'Content-Type': 'text/plain; charset=utf-8'} <<< cors
                res.end query
              else
                query =
                  \flag : 2
                  \office : office
                  \sect : sec-id
                  \landno : num
                uri = base + \? + querystring.stringify query
                error,response,body <- request {'url':uri, 'encoding':'utf-8', 'method': 'GET', 'headers': {'Referer':'http://maps.nlsc.gov.tw/O09/mapshow.action'}}
                console.log addr
                if body?
                  result = JSON.parse body
                  result.push 'source: http://maps.nlsc.gov.tw/'
                  res.writeHead 200, {'Content-Type': 'application/json; charset=utf-8'} <<< cors
                  res.end JSON.stringify result
                else
                  res.writeHead 404, {'Content-Type': 'application/json; charset=utf-8'} <<< cors
                  res.end '{"error":"not found", "msg":"找不到你輸入的地址"}';
      else
        res.writeHead 404, {'Content-Type': 'application/json; charset=utf-8'} <<< cors
        res.end '{"error":"wrong format", "msg":"錯誤的地號格式，需縣市鄉鎮市區段號碼：[桃園縣蘆竹鄉內興段632]"}';
  else
    res.writeHead 404, {'Content-Type': 'application/json; charset=utf-8'} <<< cors
    res.end '{"error":"wrong request", "msg":"錯誤的傳入參數，需帶入完整地址[?address=臺北市信義區市府路1號]，或完整地號[?landno=桃園縣蘆竹鄉內興段632]"}';

server.listen 9192
