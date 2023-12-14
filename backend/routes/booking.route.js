const express = require('express')
const router = express.Router()
const BookingController = require('../controllers/booking.controller');

router.get('/verWorkerList', BookingController.verifiedWorkerList);

module.exports = router;