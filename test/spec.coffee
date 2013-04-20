
fs            = require 'fs'
stream        = require 'stream'
stream.Bucket = require '../'
assert        = require 'assert'

it "should do it's thing with pipes", (done) ->
    bucket = new stream.Bucket
    fs.createReadStream('test/a.txt').pipe(bucket)
    fs.createReadStream('test/b.txt').pipe(bucket)

    bucket.on 'end', (data) ->
        str = data.toString()
        assert.equal str.match(/\w/g).length, 19
        assert.equal str.match(/a/g).length, 9
        assert.equal str.match(/b/g).length, 10
        done()

it "should do it's thing with .catch", (done) ->
    new stream.Bucket()
        .catch(fs.createReadStream('test/a.txt'))
        .catch(fs.createReadStream('test/b.txt'))
        .on 'end', (data) ->
            str = data.toString()
            assert.equal str.match(/\w/g).length, 19
            assert.equal str.match(/a/g).length, 9
            assert.equal str.match(/b/g).length, 10
            done()

it "should do it's thing with stringMode", (done) ->
    new stream.Bucket(String)
        .catch(fs.createReadStream('test/a.txt'))
        .catch(fs.createReadStream('test/b.txt'))
        .on 'end', (str) ->
            assert.equal str.match(/\w/g).length, 19
            assert.equal str.match(/a/g).length, 9
            assert.equal str.match(/b/g).length, 10
            done()

it "should do it's thing with objectMode", (done) ->
    new stream.Bucket({ objectMode: true })
        .catch(fs.createReadStream('test/a.txt'))
        .catch(fs.createReadStream('test/b.txt'))
        .on 'end', (data) ->
            str = data.join('')
            assert.equal str.match(/\w/g).length, 19
            assert.equal str.match(/a/g).length, 9
            assert.equal str.match(/b/g).length, 10
            done()
