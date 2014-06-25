// Generated by LiveScript 1.2.0
(function(){
  var http, url, fs, querystring, request, json, base, gmap, cors, server, replace$ = ''.replace;
  http = require('http');
  url = require('url');
  fs = require('fs');
  querystring = require('querystring');
  request = require('request');
  json = JSON.parse(fs.readFileSync('section.json', 'utf-8'));
  base = 'http://landmaps.nlsc.gov.tw/S_Maps/qryTileMapIndex';
  gmap = 'http://maps.google.com/maps/api/geocode/json?sensor=false&language=zh-tw&region=tw&address=';
  cors = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'X-Requested-With,Content-Type,If-Modified-Since',
    'Access-Control-Allow-Methods': 'GET,POST,PUT'
  };
  server = http.createServer(function(req, res){
    var p, q, addr, matches, uri, cityArea, areaId, sec, secId, num, office, query;
    if (req.method === 'OPTIONS') {
      res.writeHead(204, cors);
      res.end();
      return;
    }
    p = url.parse(decodeURIComponent(req.url));
    q = querystring.parse(p.query);
    if (q.address != null) {
      addr = q.address.replace(/台/g, '臺');
      matches = /(..(?:市|縣))(.{1,3}(?:鄉|鎮|市|區))(.{2,8}路)(.*)/gi.exec(addr);
      if (matches != null) {
        uri = gmap + addr;
        return request({
          'url': uri,
          'encoding': 'utf-8',
          'method': 'GET'
        }, function(error, response, body){
          var result;
          result = JSON.parse(body);
          result.source = uri;
          res.writeHead(200, import$({
            'Content-Type': 'application/json'
          }, cors));
          return res.end(JSON.stringify(result));
        });
      } else {
        matches = /(..(?:市|縣))(.{1,2}(?:鄉|鎮|市|區))(.{2,8}段)(.*)/gi.exec(addr);
        uri = '';
        if (matches != null) {
          cityArea = matches[1] + matches[2];
          if (typeof json.area[cityArea] !== 'undefined') {
            areaId = json.area[cityArea];
            sec = matches[3];
            if (typeof json.section[areaId][sec] !== 'undefined') {
              secId = json.section[areaId][sec].id;
              matches[4] = matches[4].replace(/之/, '-');
              num = replace$.call(matches[4], /[^\d-]/g, '');
              office = json.section[areaId][sec].o;
              if (num != null) {
                if (q.magic != null) {
                  query = "lands[]=" + matches[1] + ',' + sec + ',' + num;
                  res.writeHead(200, import$({
                    'Content-Type': 'text/plain; charset=utf-8'
                  }, cors));
                  return res.end(query);
                } else {
                  query = {
                    'flag': 2,
                    'office': office,
                    'sect': secId,
                    'landno': num
                  };
                  uri = base + '?' + querystring.stringify(query);
                  return request({
                    'url': uri,
                    'encoding': 'utf-8',
                    'method': 'GET',
                    'headers': {
                      'Referer': 'http://maps.nlsc.gov.tw/O09/mapshow.action'
                    }
                  }, function(error, response, body){
                    var result;
                    console.log(addr);
                    if (body != null) {
                      result = JSON.parse(body);
                      result.push('source: http://maps.nlsc.gov.tw/');
                      res.writeHead(200, import$({
                        'Content-Type': 'application/json; charset=utf-8'
                      }, cors));
                      return res.end(JSON.stringify(result));
                    } else {
                      res.writeHead(404, import$({
                        'Content-Type': 'application/json; charset=utf-8'
                      }, cors));
                      return res.end('{"error":"not found", "msg":"找不到你輸入的地址"}');
                    }
                  });
                }
              }
            }
          }
        } else {
          res.writeHead(404, import$({
            'Content-Type': 'application/json; charset=utf-8'
          }, cors));
          return res.end('{"error":"wrong format", "msg":"錯誤的地號格式，需縣市鄉鎮市區段號碼：[桃園縣蘆竹鄉內興段632]"}');
        }
      }
    } else {
      res.writeHead(404, import$({
        'Content-Type': 'application/json; charset=utf-8'
      }, cors));
      return res.end('{"error":"wrong request", "msg":"錯誤的傳入參數，需帶入完整地址或完整地號[?address=臺北市信義區市府路1號]"}');
    }
  });
  server.listen(9192);
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
