require('dotenv').config();

const path = require('path');
const express = require('express');
const app = express();
const port = process.env.PORT || 1337;
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
app.use(express.static(path.join(__dirname, 'src/pages')));

// This is the main route for the url
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

app.use("/v1", router);

app.use((req, res) => {
    res.json({
        errors: {
            msg: "Hmm.. route dosen't exist."
        }
    }).status(404);
});

app.listen(port, console.log(`App is listening on ${port}`));
