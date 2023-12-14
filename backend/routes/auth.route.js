const express = require('express')
const router = express.Router()
const AuthController = require('../controllers/auth.controller');

router.post('/login', AuthController.login);
router.post('/register', AuthController.register);
router.post('/checkEmail', AuthController.checkEmail);

// router.get('/:id', (req, res) => {
//     res.json({ msg: 'GET one user data' })
// })

// router.post('/', (req, res) => {
//     res.json({ msg: 'POST new user' })
// })

// router.delete('/:id', (req, res) => {
//     res.json({ msg: 'DELETE a user data' })
// })

// router.patch('/:id', (req, res) => {
//     res.json({ msg: 'UPDATE a user data' })
// })

module.exports = router;