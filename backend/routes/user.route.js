const express = require('express')
const router = express.Router()
const UserController = require('../controllers/user.controller');

router.get('/allUsers', UserController.allUsers);
router.post('/uploadPicture', UserController.uploadPicture);
router.patch('/uploadKYC/:id', UserController.uploadKYC);
router.patch('/updateStatus/:id/:status', UserController.updateStatus);

module.exports = router;