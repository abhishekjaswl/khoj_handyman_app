const express = require('express')
const router = express.Router()
const BookingController = require('../controllers/booking.controller');

router.get('/verWorkerList', BookingController.verifiedWorkerList);
router.post('/postBookingRequest', BookingController.postBookingRequest);

module.exports = router;