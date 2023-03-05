import QtQuick 2.0

/*
 * Linear translate data coordinate to drawing coordinate.
 */
QtObject {

    property var domain: [0, 1]     // data coordinate
    property var range: [0, 1]      // drawing coordinate

    property double factor: NaN

    onDomainChanged: computeFactor()
    onRangeChanged: computeFactor()

    function computeFactor() {
        factor = (range[1] - range[0]) / (domain[1] - domain[0])
    }

    function setDomain(d0, d1) {
        domain = [d0, d1]
    }

    function setRange(r0, r1) {
        range = [r0, r1]
    }

    /* Translate a data value into drawing coordinates */
    function translate(val) {
        return range[0] + (factor * (val - domain[0]))
    }

    /* Translate a drawing coordinate to data value */
    function invert(val) {
        return domain[0] + (val - range[0]) / factor
    }
}
