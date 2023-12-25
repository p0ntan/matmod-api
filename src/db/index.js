const mariadb = require('mariadb');

const pool = mariadb.createPool({
    // socketPath: '/var/lib/mysql/mysql.sock',
    host: 'mariadb',
    user: `root`,
    // password: '',
    database: 'lent_weather',
    connectionLimit: 5
});

const allData = "CALL get_data();"
const dailyData = "CALL get_daily_average();"
const weeklyData = "CALL get_weekly_average();"
const monthlyData = "CALL get_monthly_average();"

async function getData(sqlQuery, args=[]) {
    let conn;

    try {
        conn = await pool.getConnection();
        const res = await conn.query(sqlQuery, args);

        return res;
  
    } catch (err) {
        throw err;
    } finally {
        if (conn) conn.end();
    }
}

module.exports = {
    getData,
    queries: {
        allData,
        dailyData,
        weeklyData,
        monthlyData
    }
}
