const express = require('express');
const app = express();
const port = 1337;
const cors = require('cors');
const bodyParser = require('body-parser');
const router = require('./src/routes/index');

const corsOptions = {
    origin: true,
    credentials: true
};

app.use(cors(corsOptions));

// Middleware
app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({ extended: true })); // for parsing application/x-www-form-urlencoded

app.use("/", router);

app.listen(port, console.log(`App is listening on ${port}`));