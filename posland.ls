require! \http
require! \url
require! \fs
require! \querystring
require! \request

json = JSON.parse fs.readFileSync \section.json,\utf-8
base = \http://landmaps.nlsc.gov.tw/S_Maps/qryTileMapIndex
server = http.createServer (req, res) ->
  p = url.parse decodeURIComponent req.url
  q = querystring.parse p.query
  if q.address?
    # handling address
    addr = q.address.replace /台/g \臺
    matches = /(..(?:市|縣))(.{1,2}(?:鄉|鎮|市|區))(.{2,8}段)(.*)/gi is addr
    uri = ''
    if matches?
      city-area = matches[1] + matches[2]
      if typeof json.area[city-area] != 'undefined'
        area-id = json.area[city-area]
        sec = matches[3]
        if typeof json.section[area-id][sec] != 'undefined'
          sec-id = json.section[area-id][sec].id
          num = matches[4] - /[^\d]/g
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
      res.writeHead 200, 'Content-Type': 'text/plain'
      res.end \404
  else
    res.writeHead 200, 'Content-Type': 'text/plain'
    res.end \404

server.listen 9192
