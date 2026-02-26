import Cocoa

let freeApp = true
if (freeApp == true){
    print("You are using the free version of the app. Buy the full version of the app to get access to all of its features.")
}

let morningTemperature = 70
let eveningTemperature = 80
if(morningTemperature < eveningTemperature){
    print("The morning's temperature is lower.")
}else{
    print("The evening's temperature is lower.")
}

let temperatureDegree = "Fahrenheit"
if(temperatureDegree == "Fahrenheit"){
    print("This app uses Fahrenheit degree.")
}else{
    print("This app uses Celsius degree.")
}


if temperatureDegree == "Celsius" || temperatureDegree == "Fahrenheit" {
  print("The weather app is configured properly.")
} else {
  print("The weather app isn't configured properly.")
}
switch temperatureDegree {
    case "Fahrenheit": print("The weather app is configured for the US.")
    case "Celsius": print("The weather app is configured for Europe.")
    default: print("The weather app has an unknown configuration.")
}