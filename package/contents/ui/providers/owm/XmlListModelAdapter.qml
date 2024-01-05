import QtQml.XmlListModel

XmlListModel {

    function get(i) {
        var o = {}
        for (var j = 0; j < roles.length; j++) {
            o[roles[j].name] = data(index(i, 0), Qt.UserRole + j)
        }
        return o
    }

    function serialize() {
        var arr = []
        for (var i = 0; i < count; i++) {
            let item = get(i)
            arr.push(item)
        }

        return JSON.stringify(arr)
    }
}
