# EdiSun
Mimic outdoor ambient light indoors with Phillips Hue bulbs, controlled by an Intel Edison.  (Ok, you could run this on anything that has the Julia language, but tiny computers are more fun!)

Sample use: update three bulbs to match the current conditions in Auckland, Portland and London. 

``` julia
using Requests, DataFrames
include("EdiSun.jl")
HueHub = "http://192.168.98.25/api"
lightsTable = DataFrame(ID = [3,1,2], City = ["Auckland", "Portland,OR,us" , "London,uk"], Name= ["Aukland","Portland", "London"])
updateAllLights(lightsTable)
```

```
Response(200 OK, 14 Headers, 471 Bytes in Body)
Updating light 3 with the color temperature from city Auckland.  The temperature is 100 and the mirek is 500.
[{"success":{"/lights/3/state/on":true}},{"success":{"/lights/3/state/ct":500}}]
http://api.openweathermap.org/data/2.5/weather?q=Portland,OR,us
Response(200 OK, 14 Headers, 486 Bytes in Body)
Updating light 1 with the color temperature from city Portland,OR,us.  The temperature is 7691.200579502059 and the mirek is 153.
[{"success":{"/lights/1/state/on":true}},{"success":{"/lights/1/state/ct":153}}]
http://api.openweathermap.org/data/2.5/weather?q=Ithaca,NY,us
Response(200 OK, 14 Headers, 480 Bytes in Body)
Updating light 2 with the color temperature from city Ithaca,NY,us.  The temperature is 5521.6145690099365 and the mirek is 181.
[{"success":{"/lights/2/state/on":true}},{"success":{"/lights/2/state/ct":181}}]
```

<img src="http://gotfork.net/archive%20for%20web/three-cities.jpg">
Lights are for Auckland, Portland and Ithaca from left to right, taken around 2:45 PM Portland time.  Note that it was still nighttime in Auckland and the getTemp function returns 100 K to force the light to show its lowest temperature value.  
