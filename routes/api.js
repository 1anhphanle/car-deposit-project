const express = require('express');
const router = express.Router();
const pool = require('../models/db');

// API để kiểm tra trạng thái giao dịch
router.get('/transaction/:transactionId', async (req, res) => {
    try {
        const { transactionId } = req.params;

        // Lấy thông tin giao dịch từ database
        const transaction = await pool.query(
            'SELECT Status_Of_Purchasing FROM dataTRANSACTION WHERE Transaction_ID = $1',
            [transactionId]
        );

        // Trả về trạng thái của giao dịch
        if (transaction.rows.length > 0) {
            res.json({ status: transaction.rows[0].status_of_purchasing });
        } else {
            res.status(404).json({ message: 'Giao dịch không tồn tại' });
        }
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Lỗi server' });
    }
});

module.exports = router;