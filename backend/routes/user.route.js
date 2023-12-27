const express = require('express')
const router = express.Router()
const UserController = require('../controllers/user.controller');

router.post('/uploadPicture', UserController.uploadPicture);
router.patch('/uploadKYC/:id', UserController.uploadKYC);
router.patch('/updateStatus/:id/:availability', UserController.updateAvailability);

module.exports = router;