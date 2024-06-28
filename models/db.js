const pg = require('pg');

const pool = new pg.Pool({
    user: 'postgres',
    host: 'localhost',
    database: 'Car_Agency_Management',
    password: '08112018',
    port: 5432, // Cổng mặc định PostgreSQL
});

module.exports = pool;