const express = require('express');
const router = express.Router();
const dbHandler = require('../db/index');

router.get('/', (req, res) => {
    res.json({
        data: {
            msg: "This is an API setup for the course matmod at BTH."
        }
    });
})

router.get('/data', async (req, res) => {
    result = await dbHandler.getData(dbHandler.queries.allData);

    res.json(result[0])
})

router.get('/data/daily', async (req, res) => {
    result = await dbHandler.getData(dbHandler.queries.dailyData);

    res.json(result[0])
})

router.get('/data/weekly', async (req, res) => {
    result = await dbHandler.getData(dbHandler.queries.weeklyData);

    res.json(result[0])
})

router.get('/data/monthly', async (req, res) => {
    result = await dbHandler.getData(dbHandler.queries.monthlyData);

    res.json(result[0])
})

module.exports = router;
