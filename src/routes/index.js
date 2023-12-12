const express = require('express');
const router = express.Router();
const dH = require('../data/index');

router.get('/', (req, res) => {
    res.json({
        data: {
            msg: "This is an API setup for the course matmod at BTH."
        }
    });
})

router.get('/data', async (req, res) => {
    result = await dH.allData()

    res.json(result)
})

module.exports = router;
