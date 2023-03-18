.pragma library

function init(self, plasmoidId) {
    let prefix = [self]
    prefix.push("[meteogram" + ((plasmoidId === undefined) ? "" : ("-" + plasmoidId) ) + "]")
    if (self.objectName.length > 0) {
        prefix.push(self.objectName + ":")
    }
    return (...args) => dbgprint.apply(self, prefix.concat(args))
}

function dbgprint(self, ...args) {
    print.apply(self, args)
}
