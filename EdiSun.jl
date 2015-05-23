function getTemp(sunrise, sunset, mult, defaultTemp)
    percentDay = (time()-sunrise)/(sunset-sunrise)
    if (percentDay>=0)&(percentDay<=1)
        return (6990.5+
        percentDay.^1*74508+
        percentDay.^2*-4.5021*10^5+
        percentDay.^3*9.5966*10^5+
        percentDay.^4*-8.6916*10^5+
        percentDay.^5*2.8073*10^5)*mult
    else
        return  defaultTemp
    end 
end

function getWeather(zip)
    res = get(string("http://api.openweathermap.org/data/2.5/weather?zip=", zip,",us"))
    sunrise = int(match(r"sunrise\":(\d+)", res.data).captures)
    sunset = int(match(r"sunset\":(\d+)", res.data).captures)
    
    #Is there extreme weather?  If so write a static multiplier
    m = match(r"weather\":\[{\"id\":(\d+)", res.data)
    mult = nothing
    if m.captures!=nothing
        code = int(m.match[17:end])
        mult = getMultFromCode(code)
    end
    if mult==nothing
        #if we don't have a code yet, estimate from cloud cover
        m = match(r"clouds\":{\"all\":(\d+)", res.data)
        mult = 1+.4*int(m.captures)/100
    end
    return [sunrise, sunset, mult]
end
    
function getMultFromCode(code)
    if floor(code/100)==2 #thunderstorm
        return 1.8
    elseif floor(code/100)==3 #drizzle
        return 1.3
    elseif floor(code/100)==5 #rain
        return 1.5
    elseif floor(code/100)==7 #haze, smoke, volcanic ash, etc
        return 1.7
    end
    return nothing  
end

function getMirek(ct)
    if ct==nothing
        return nothing
    end
    mirek = 1/ct*10^6
    if mirek>500
        mirek = 500
    elseif mirek<153
        mirek = 153
    end
    return int(floor(mirek))
end

function setLight(whichLight, mirek)
    if mirek==nothing
        onVal=false
        mirek=500
    else
        onVal=true
    end 
    req = string("{\"on\":",onVal,", \"ct\":", mirek, "}")
    
    println(put(string(HueHub, "/newdeveloper/lights/", whichLight,"/state"); 
    data= req).data)
end

function updateLightFromZip(whichLight, zip)
    (sunrise, sunset, mult) = getWeather(zip)
    ct = getTemp(sunrise, sunset, mult, nothing)
    mirek = getMirek(ct)
    println("Updating light ", whichLight, " with the color temperature from zip code ",
    zip, ".  The temperature is ", ct, " and the mirek is ", mirek, ".")
    setLight(whichLight, mirek)
end

function keepLightsUpdated(lightsTable)
    while true
    for i=1:nrow(lightsTable)
        updateLightFromZip(lightsTable[i,:ID],lightsTable[i,:zip])
    end
    sleep(10)
    end
end
