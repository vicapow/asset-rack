
should = require('chai').should()
rack = require '../.'
express = require 'express.io'
easyrequest = require 'request'
fs = require 'fs'

describe 'a stylus asset', ->
    app = null

    it 'should work', (done) ->
        compiled = fs.readFileSync './fixtures/stylus/simple.css', 'utf8'
        app = express().http()
        app.use new rack.StylusAsset
            filename: "#{__dirname}/fixtures/stylus/simple.styl"
            url: '/style.css'
        app.listen 7076, ->
            easyrequest 'http://localhost:7076/style.css', (error, response, body) ->
                response.headers['content-type'].should.equal 'text/css'
                body.should.equal compiled
                done()

    it 'should work compressed', (done) ->
        compiled = fs.readFileSync './fixtures/stylus/simple.min.css', 'utf8'
        app = express().http()
        app.use new rack.StylusAsset
            filename: "#{__dirname}/fixtures/stylus/simple.styl"
            url: '/style.css'
            compress: true
        app.listen 7076, ->
            easyrequest 'http://localhost:7076/style.css', (error, response, body) ->
                response.headers['content-type'].should.equal 'text/css'
                body.should.equal compiled
                done()

        
    afterEach (done) -> process.nextTick ->
        app.server.close done