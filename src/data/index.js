const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');

const dataHandler = {
    allData: function allData() {
        return Promise.all(['2022.csv', '2023.csv'].map(file => {
            return new Promise((resolve, reject) => {
                const results = [];
                fs.createReadStream(path.join(path.dirname(__filename), file))
                    .pipe(csv())
                    .on('data', (data) => results.push(data))
                    .on('end', () => {
                        resolve(results);
                    })
                    .on('error', reject);
            });
        })).then(arrays => arrays.reduce((acc, curr) => acc.concat(curr), []));
    }
}

module.exports = dataHandler;
