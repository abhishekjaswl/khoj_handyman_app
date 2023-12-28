const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const bookingSchema = new Schema({
    userId: {
        type: String,
        required: true
    },
    dateTime: {
        type: Date,
        required: true
    }, status: {
        type: String,
        enum: ['accepted', 'declined'],
        default: 'available'
    },
});

const workerSchema = new Schema({
    job: {
        type: String,
        lowercase: true
    },
    paymentQrUrl: {
        type: String,
    },
    availability: {
        type: String,
        enum: ['available', 'unavailable'],
        default: 'available'
    },
    bookingRequests: [bookingSchema],
    bookingHistory: [bookingSchema]
});

const WorkerModel = db.model('worker', workerSchema);

module.exports = WorkerModel;
