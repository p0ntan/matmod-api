const express = require('express');
const router = express.Router();
const dataRouter = require('./data');
const dayRouter = require('./day');

router.get('/', (req, res) => {
    res.json({
        data: {
            msg: "This is an API setup for the course matmod at BTH."
        }
    });
})

router.use('/data', dataRouter);
router.use('/day', dayRouter);

module.exports = router;
