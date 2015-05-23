# EdiSun
Mimic outdoor ambient light indoors with <a href="http://www2.meethue.com/en-us/">Phillips Hue</a> bulbs, controlled by an <a href="https://software.intel.com/en-us/iot/hardware/edison">Intel Edison</a>.  (Ok, you could run this on anything that has the <a href="http://julialang.org/">Julia language</a>, but tiny computers are more fun!)

It uses the <a href="http://openweathermap.org">OpenWeatherMap API</a> to get the local time, weather conditions and cloud cover for a given city, and then estimates the color temperature of ambient outdoor light using a simple model.   This color temperature can then be passed to a Hue bulb to match the outdoor conditions.  Note that the version of the Hue that we use only goes up to 6500 K and down to 2000 K, so values are sometimes clipped.  At night, the Hue goes to a default value, here 2000 K.  

Sample use: Update three bulbs to match the current conditions in Auckland, Portland and Ithaca, NY. 

``` julia
using Requests, DataFrames
include("EdiSun.jl")
HueHub = "http://192.168.98.25/api"
lightsTable = DataFrame(ID = [3,1,2], City = ["Auckland", "Portland,OR,us" , "London,uk"],
    Name= ["Aukland","Portland", "London"])
updateAllLights(lightsTable)
```

```
Response(200 OK, 14 Headers, 471 Bytes in Body)
Updating light 3 with the color temperature from city Auckland.  The temperature is 100 and the mirek is 500.
[{"success":{"/lights/3/state/on":true}},{"success":{"/lights/3/state/ct":500}}]
http://api.openweathermap.org/data/2.5/weather?q=Portland,OR,us
Response(200 OK, 14 Headers, 486 Bytes in Body)
Updating light 1 with the color temperature from city Portland,OR,us.  The temperature is 7691.200579502059 
    and the mirek is 153.
[{"success":{"/lights/1/state/on":true}},{"success":{"/lights/1/state/ct":153}}]
http://api.openweathermap.org/data/2.5/weather?q=Ithaca,NY,us
Response(200 OK, 14 Headers, 480 Bytes in Body)
Updating light 2 with the color temperature from city Ithaca,NY,us.  The temperature is 5521.6145690099365
    and the mirek is 181.
[{"success":{"/lights/2/state/on":true}},{"success":{"/lights/2/state/ct":181}}]
```

<img src="http://gotfork.net/archive%20for%20web/three-cities2.jpg">
Lights are for Auckland, Portland and Ithaca from left to right, taken around 4:00 PM Portland time.  Note that it was just before dawn in Auckland  and the getTemp function returns 100 K to force the light to show its lowest temperature value.  
