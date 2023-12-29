const express = require('express');
const router = express.Router();
const dbHandler = require('../db/index');

router.get('/', async (req, res) => {
    result = await dbHandler.getData(dbHandler.queries.allData);

    res.json(result[0])
})

router.get('/daily', async (req, res) => {
    result = await dbHandler.getData(dbHandler.queries.dailyData);

    res.json(result[0])
})

router.get('/weekly', async (req, res) => {
    result = await dbHandler.getData(dbHandler.queries.weeklyData);

    res.json(result[0])
})

router.get('/monthly', async (req, res) => {
    result = await dbHandler.getData(dbHandler.queries.monthlyData);

    res.json(result[0])
})

module.exports = router;
