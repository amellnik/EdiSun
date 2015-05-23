# EdiSun
Mimic outdoor ambient light indoors with Phillips Hue bulbs, controlled by an Intel Edison.  

Sample use: update three bulbs to match the current conditions in Aukland, Portland and London.  (Note that when this was run it was night in London, and the light defaults to the lowest-temperature value possible). 

``` julia
using Requests, DataFrames
HueHub = "http://192.168.98.25/api"
lightsTable = DataFrame(ID = [3,1,2], City = ["Auckland", "Portland,OR,us" , "London,uk"], Name= ["Aukland","Portland", "London"])
updateAllLights(lightsTable)
```

```
http://api.openweathermap.org/data/2.5/weather?q=Auckland
Response(200 OK, 14 Headers, 471 Bytes in Body)
Updating light 3 with the color temperature from city Auckland.  The temperature is 100 and the mirek is 500.
[{"success":{"/lights/3/state/on":true}},{"success":{"/lights/3/state/ct":500}}]
http://api.openweathermap.org/data/2.5/weather?q=Portland,OR,us
Response(200 OK, 14 Headers, 486 Bytes in Body)
Updating light 1 with the color temperature from city Portland,OR,us.  The temperature is 7647.549452191086 and the mirek is 153.
[{"success":{"/lights/1/state/on":true}},{"success":{"/lights/1/state/ct":153}}]
http://api.openweathermap.org/data/2.5/weather?q=London,uk
Response(200 OK, 14 Headers, 466 Bytes in Body)
Updating light 2 with the color temperature from city London,uk.  The temperature is 100 and the mirek is 500.
[{"success":{"/lights/2/state/on":true}},{"success":{"/lights/2/state/ct":500}}]
```

<img src="http://gotfork.net/archive%20for%20web/three-cities.jpg">
    
