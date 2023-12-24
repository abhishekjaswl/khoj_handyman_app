const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const workerSchema = new Schema({
    job: {
        type: String,
        lowercase: true
    },
    paymentQrUrl: {
        type: String,
        default: ''
    },
    status: {
        type: String,
        enum: ['available', 'unavailable'],
        default: 'available'
    },
});

const WorkerModel = db.model('worker', workerSchema);

module.exports = WorkerModel;
