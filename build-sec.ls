require! request
require! cheerio
require! fs

json =
  city:
    \A : \臺北市
    \B : \臺中市
    \C : \基隆市
    \D : \臺南市
    \E : \高雄市
    \F : \新北市
    \G : \宜蘭縣
    \H : \桃園縣
    \I : \嘉義市
    \J : \新竹縣
    \K : \苗栗縣
    \M : \南投縣
    \N : \彰化縣
    \O : \新竹市
    \P : \雲林縣
    \Q : \嘉義縣
    \T : \屏東縣
    \U : \花蓮縣
    \V : \臺東縣
    \W : \金門縣
    \X : \澎湖縣
    \Z : \連江縣
  area: {}
  section: {}
req_area = \http://maps.nlsc.gov.tw/O09/pro/setArea.jsp
for c of json.city => let c
  error,response,body <- request {'url':req_area, 'encoding':'utf-8', 'method': 'POST', 'qs': {'city':c}}
  $ = cheerio.load body
  codes = $ \country .children!
  codes.each ->
    id = $ this .find \id .text!
    name = $ this .find \name .text!
    city = json.city[c]
    idx = city + name
    json.area[idx] = id
    json.section[id] = {}
    req_sec = \http://maps.nlsc.gov.tw/O09/pro/setSection.jsp
    err,res,bo <- request {'url':req_sec, 'encoding':'utf-8', 'method':'POST', 'qs': {'city':c, 'area': id}}
    $$ = cheerio.load bo
    secs = $$ \country .children!
    secs.each ->
      $id = $ this .find \id .text!
      $name = $ this .find \name .text!
      $office = $ this .find \office .text!
      json.section[id][$name] = {'id':$id, 'o':$office}

setTimeout ->
  output = JSON.stringify json
  fs.writeFile \section.json output
,300*1000
