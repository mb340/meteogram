import QtQuick 2.0


// Compatible with the data interface of XmlListModel.
// So data can be loaded from disk cache rather than fetching from a URL.
QtObject {

	property var data: []

	property var count: data.length

	function get(index) {
		return data[index]
	}
}
