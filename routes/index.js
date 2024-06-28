const express = require('express');
const router = express.Router();
const pool = require('../models/db');

router.get('/', async (req, res) => {
    try {
        const cars = await pool.query('SELECT * FROM dataCAR');
        res.render('client', { cars: cars.rows });
    } catch (error) {
        console.error(error);
        res.status(500).send('Lỗi server');
    }
});

router.post('/dat-coc', async (req, res) => {
    try {
        const { modelCarId, hoTen, cccd, soDienThoai, email, diaChi } = req.body;

        // Kiểm tra xem khách hàng đã tồn tại trong database chưa
        const customerExists = await pool.query(
            'SELECT 1 FROM dataCUSTOMER WHERE Citizen_ID = $1',
            [cccd]
        );

        if (customerExists.rows.length === 0) {
            // Nếu khách hàng chưa tồn tại, thêm khách hàng mới vào database
            await pool.query(
                'INSERT INTO dataCUSTOMER (Citizen_ID, Email, Customer_Name, Phone_No, Address, Number_Transaction) VALUES ($1, $2, $3, $4, $5, $6)',
                [cccd, email, hoTen, soDienThoai, diaChi, 0] // Giả sử Number_Transaction ban đầu là 0
            );
        }

        // Lấy thông tin xe từ database
        const carInfo = await pool.query(
            'SELECT * FROM dataCAR WHERE Model_Car_ID = $1',
            [modelCarId]
        );

        // Kiểm tra xem xe có tồn tại không
        if (carInfo.rows.length === 0) {
            return res.status(400).send('Xe không tồn tại.');
        }

        // Kiểm tra xem xe còn hàng hay không
        const carAvailability = carInfo.rows[0].Car_Number_Availability;
        if (carAvailability <= 0) {
            return res.status(400).send('Xe đã hết hàng.');
        }

        // Tính toán ngày hết hạn bảo hành (giả sử bảo hành 1 năm)
        const warrantyValidDate = new Date();
        warrantyValidDate.setFullYear(warrantyValidDate.getFullYear() + 1);

        // Chuyển đổi đối tượng Date thành chuỗi ngày tháng có định dạng YYYY-MM-DD
        const formattedWarrantyValidDate = warrantyValidDate.toISOString().slice(0, 10);
        const formattedPaymentDate = new Date().toISOString().slice(0, 10);

        // Chèn dữ liệu giao dịch mới vào bảng dataTRANSACTION
        const newTransaction = await pool.query(
            'INSERT INTO dataTRANSACTION (Transaction_ID, Citizen_ID, Model_Car_ID, Transaction_Date, Payment_Date, Warranty_Valid_Date, Status_Of_Purchasing) VALUES ($1, $2, $3, $4, $5, $6, $7)',
            [
                `${Date.now()}-${Math.floor(Math.random() * 10000)}`,
                cccd,
                modelCarId,
                new Date(),
                formattedPaymentDate,
                formattedWarrantyValidDate,
                'deposited' // Cập nhật trạng thái là 'deposited'
            ]
        );

        if (newTransaction.rowCount > 0) {
            // Cập nhật số lượng giao dịch của khách hàng
            await pool.query(
                'UPDATE dataCUSTOMER SET Number_Transaction = Number_Transaction + 1 WHERE Citizen_ID = $1',
                [cccd]
            );

            res.send('Đặt cọc thành công. Đang chờ xác nhận từ admin.');
        } else {
            res.status(500).send('Lỗi server');
        }
    } catch (error) {
        console.error(error);
        res.status(500).send('Lỗi server');
    }
});

// API để trả về trạng thái của giao dịch
router.get('/api/transaction/:transactionId', async (req, res) => {
    try {
        const { transactionId } = req.params;

        const transaction = await pool.query(
            'SELECT Status_Of_Purchasing FROM dataTRANSACTION WHERE Transaction_ID = $1',
            [transactionId]
        );

        if (transaction.rows.length > 0) {
            const status = transaction.rows[0].status_of_purchasing;
            res.json({ status });
        } else {
            res.status(404).send('Giao dịch không tồn tại.');
        }
    } catch (error) {
        console.error(error);
        res.status(500).send('Lỗi server');
    }
});

module.exports = router;