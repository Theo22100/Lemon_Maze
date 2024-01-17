'use strict';
const express = require('express');
const udRoute = express.Router();
const connection = require('../db');
udRoute.post('/update', function (req, res, next) {
    connection.execute("UPDATE persons SET name=?, surName=? WHERE id=?;",
        [req.body.name, req.body.surName, req.body.id])
        .then(() => {
            console.log('ok');
        }).catch((err) => {
            console.log(err);
        });
    res.end();
});
udRoute.post('/delete', function (req, res, next) {
    connection.execute("DELETE FROM persons WHERE id=?;",
        [req.body.id])
        .then(() => {
            console.log('ok');
        }).catch((err) => {
            console.log(err);
        });
    res.end();
});
udRoute.use('/', function (req, res, next) {
    res.sendStatus(404);
})
module.exports = udRoute;