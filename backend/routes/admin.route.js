const express = require('express')
const router = express.Router()
const AdminController = require('../controllers/admin.controller');

router.get('/allUsers', AdminController.allUsers);
router.get('/userList', AdminController.userList);
router.get('/workerList', AdminController.workerList);
router.get('/pendingList', AdminController.pendingList);
router.patch('/updateStatus/:id/:status', AdminController.updateUserStatus);

module.exports = router;