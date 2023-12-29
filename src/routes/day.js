const express = require('express');
const router = express.Router();
const dbHandler = require('../db/index');

router.get('/', async (req, res) => {
    day = req.query.day;

    result = await dbHandler.getData(dbHandler.queries.singleDay, [day]);
    res.json(result[0])
})

module.exports = router;
