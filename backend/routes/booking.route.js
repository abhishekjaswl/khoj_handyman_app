const express = require('express')
const router = express.Router()
const BookingController = require('../controllers/booking.controller');

router.get('/verWorkerList', BookingController.verifiedWorkerList);
router.post('/postBookingRequest', BookingController.postBookingRequest);
router.get('/getBookingRequests/:id', BookingController.getBookingRequests);
router.get('/getBookingHistory/:id', BookingController.getBookingHistory);
router.get('/getCurrentBookings/:id', BookingController.getCurrentBookings);
router.get('/getUserBookReq/:uid', BookingController.getUserBookReq);
router.get('/getUserBookHistory/:uid', BookingController.getUserBookHistory);
router.patch('/updateBookingRequest/:id/:status', BookingController.updateBookingRequest);
router.patch('/updateCurrentBooking/:id/:status', BookingController.updateCurrentBooking);

module.exports = router;