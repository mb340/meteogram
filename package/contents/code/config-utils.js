function getPlacesArray() {
    var cfgPlaces = plasmoid.configuration.places
//     print('Reading places from configuration: ' + cfgPlaces)
    return JSON.parse(cfgPlaces)
}

function formatPlaceIdentifier(placeObject) {
    let placeIdentifier = null

    if (placeObject.providerId === "metno" ||
        placeObject.providerId === "openMeteo" ||
        placeObject.providerId === "owm2")
    {
        let lat = parseFloat(placeObject.latitude).toFixed(4)
        let lon = parseFloat(placeObject.longitude).toFixed(4)
        let alt = parseInt(placeObject.altitude)
        placeIdentifier = "latitude=" + lat + "&longitude=" + lon + "&altitude=" + alt
    }

    if (placeObject.providerId === "owm") {
        placeIdentifier = placeObject.placeIdentifier
    }

    if (placeIdentifier === null) {
        console.exception("Invalid place identifier.")
        print("placeObject =", JSON.stringify(placeObject))
        return undefined
    }

    return placeIdentifier
}
