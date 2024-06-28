const express = require('express');
const router = express.Router();
const pool = require('../models/db');

router.get('/', async (req, res) => {
    try {
        const transactions = await pool.query('SELECT * FROM dataTRANSACTION');
        res.render('admin', { transactions: transactions.rows });
    } catch (error) {
        console.error(error);
        res.status(500).send('Lỗi server');
    }
});

router.post('/xac-nhan/:transactionId', async (req, res) => {
    try {
        const { transactionId } = req.params;

        const updatedTransaction = await pool.query(
            'UPDATE dataTRANSACTION SET Status_Of_Purchasing = $1 WHERE Transaction_ID = $2',
            ['paid', transactionId] // Cập nhật trạng thái là 'paid'
        );

        if (updatedTransaction.rowCount > 0) {
            // Chuyển hướng về trang dashboard admin
            res.redirect('/admin');
        } else {
            res.status(500).send('Lỗi server');
        }
    } catch (error) {
        console.error(error);
        res.status(500).send('Lỗi server');
    }
});

module.exports = router;