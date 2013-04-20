var util   = require('util')
  , stream = require('stream')

// stream.Bucket
// ----------------------------------------------------------------------------
// Collects `data` chunks into a String or Array.

function Bucket (options) {
    stream.Writable.call(this, options)

    // shortcut for creating stringMode buckets:
    // `fs.createReadStream('x.txt').pipe(Bucket(String)).on('end', ...)
    if (options === String)    options = { stringMode: true }
    if (options === undefined) options = {}

    this.objectMode = options.objectMode || false
    this.stringMode = options.stringMode || false
    this.data       = options.stringMode ? '' : options.objectMode ? [] : new Buffer(0)
    this.maxSize    = options.maxSize || 2 * 1024 * 1024

    this.on('finish', function(){
        this.emit('end', this.data)
    })
}

util.inherits(Bucket, stream.Writable)

Bucket.prototype._write = function (chunk, encoding, callback) {
    if (this.stringMode) {
        this.data += chunk.toString(encoding)
    } else if (this.objectMode) {
        this.data.push(chunk)
    } else {
        this.data = Buffer.concat([this.data, chunk])
    }
    if (this.data.length > this.maxSize) {
        this.emit('error', new Error('bucket maxSize exceeded'))
    }
    callback()
}

Bucket.prototype.catch = function (stream) {
    stream.pipe(this)
    return this
}

// ----------------------------------------------------------------------------

module.exports = Bucket
