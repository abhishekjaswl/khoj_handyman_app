const express = require('express')
const router = express.Router()
const UserController = require('../controllers/user.controller');
const { requireAuth } = require('../services/auth.service');

router.get('/allUsers', requireAuth, UserController.allUsers);

module.exports = router;