const express = require('express')
const router = express.Router()
const UserController = require('../controllers/user.controller');

router.get('/allUsers', UserController.allUsers);
router.post('/uploadProfilePic', UserController.uploadProfilePic);

module.exports = router;