const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require('bcrypt');

const { Schema } = mongoose;

const otpSchema = new Schema({
    email: {
        type: String,
        lowercase: true,
        required: true
    },
    otp: {
        type: Number,
        required: true,
    },
    purpose: {
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
        expires: 600 // Set to expire in 600 seconds (10 minutes)
    }
});

const otpModel = db.model('otp', otpSchema);

module.exports = otpModel;