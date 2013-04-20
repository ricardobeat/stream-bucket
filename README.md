stream.Bucket
=============

![stream.Bucket](http://i.imgur.com/9KjTx8i.png)

Consolidate and collect data from multiple streams:

    stream = require('stream')
    stream.Bucket = require('stream-bucket')
    obladi = require('oblada')

    s1 = obladi(1).createReadStream()
    s2 = obladi(2).createReadStream()
    bucket = new stream.Bucket({ objectMode: true })

    s1.pipe(bucket)
    s2.pipe(bucket)

    bucket.on('end', function(data){
        // both streams' data interleaved
    })

    // alternatively:

    new stream.Bucket()
        .catch(s1)
        .catch(s2)
        .on('end', function(data){
            // ...
        })

For a more complex solution that preserves data order for each piped stream see https://github.com/felixge/node-combined-stream