posland
=======
台灣地址/地號經緯度查詢

- 地號來源: http://maps.nlsc.gov.tw/
- 地址來源: https://developers.google.com/maps/documentation/geocoding/
  - 限制：每24小時內2500次
  - TODO：port maps.nlsc.gov.tw to here

Support Docker
--------
docker run -d -p 80:9192 philipz/posland:0.0.1

Base url
--------
http://posland.g0v.io

地號
----
Sample Request:
```
/?landno=臺中市北區水源段282之5
/?address=台北市大安區羅斯福路四段1號
```
Sample URL:
- http://goo.gl/vP8a8x

Sample Response:
```json
[
  {
    sectStr:"5rC05rqQ5q61",
    sect:"0301",
    officeStr:"5Lit5q2j",
    office:"BB",
    landno:"02820005"
  },
  {
    image:"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moleAABA/JoJXgAAQPya+WsGAADEr4leAABA/JoJXgAAQPyaiV4AAED8mgleAABA/JqJXgAAQPyaiV4AAED8muAFAAAQvyZ6AQAAxK+JXgAAQPyaCV4AAED8moleAABA/JoJXgAAQPya6AUAABC/JnoBAADErwleAAAA8WuiFwAAQPya6AUAAMSvmeAFAADEr4leAAAA8WuCFwAAQPya6AUAABC/JnoBAADErwleAAAA8WuiFwAAQPyKXgAAAPFrghcAAED8mugFAAAQvyZ6AQAAxK8JXgAAAPFrohcAAED8il4AAADEr+AFAABA/IpeAAAA8WuiFwAAQPya4AUAABC/JnoBAADEr+gFAABA/ApeAAAAxK/oBQAAQPwKXgAAAPFrohcAAED8mugFAAAQv4IXAAAA8St6AQAAEL+iFwAAAPEreAEAABC/ohcAAADxK3oBAADEr+AFAABA/IpeAAAAxK/oBQAAQPwKXgAAAMSv6AUAAED8il4AAAAm49dTBAAAIBu/nh4AAADZ+PXUAAAASMavJwUAAEA2fj0hAAAAkvHrqQAAAJCNX08DAACAbPx6CgAAACTj1+UBAADIxq+LAwAAkI1flwYAACAZv64LAABANn5dFQAAgGz8uiYAAADJ+HVBAAAAsvHrcgAAACTj17UAAADIxq8rAQAAkI1f1wEAACAZvy4CAABANn5dAuC1L2X6Yw7aADaoAAAAAElFTkSuQmCC",
    cx:120.68290203809738,
    cy:24.154537684453814,
    lx:120.68161725997925,
    ly:24.15370925023539,
    rx:120.68418681621553,
    ry:24.15536611867224
  },
  "source: http://landmaps.nlsc.gov.tw/S_Maps/qryTileMapIndex?flag=2&office=BB&sect=0301&landno=282-5"
]
```

地址
----
TODO:
- 直接用 maps.nlsc.gov.tw 進行地址座標反查
- 模糊定位

Sample Request:
```
/?address=臺北市信義區市府路1號
```
Sample URL: 
- http://goo.gl/Zoguqy

Sample Response:
```json
{
  results:[
    {
      address_components:[
        {
          long_name:"1",
          short_name:"1",
          types:[
            "street_number"
          ]
        },
        {
          long_name:"市府路",
          short_name:"市府路",
          types:[
            "route"
          ]
        },
        {
          long_name:"西村里",
          short_name:"西村里",
          types:[
            "sublocality",
            "political"
          ]
        },
        {
          long_name:"信義區",
          short_name:"信義區",
          types:[
            "locality",
            "political"
          ]
        },
        {
          long_name:"台北市",
          short_name:"北市",
          types:[
            "administrative_area_level_2",
            "political"
          ]
        },
        {
          long_name:"台灣",
          short_name:"TW",
          types:[
            "country",
            "political"
          ]
        },
        {
          long_name:"110",
          short_name:"110",
          types:[
            "postal_code"
          ]
        }
      ],
      formatted_address:"110台灣台北市信義區市府路1號",
      geometry:{
        location:{
          lat:25.037525,
          lng:121.563782
        },
        location_type:"ROOFTOP",
        viewport:{
          northeast:{
            lat:25.0388739802915,
            lng:121.5651309802915
          },
          southwest:{
            lat:25.0361760197085,
            lng:121.5624330197085
          }
        }
      },
      partial_match:true,
      types:[
        "street_address"
      ]
    }
  ],
  status:"OK",
  source:"http://maps.google.com/maps/api/geocode/json?sensor=false&language=zh-tw&region=tw&address=臺北市信義區市府路1號"
}
```

