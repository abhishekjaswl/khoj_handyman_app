const mongoose = require('mongoose');
const db = require('../config/db');

const { Schema } = mongoose;

const workerSchema = new Schema({
    email: {
        type: String,
        lowercase: true
    },
    job: {
        type: String,
        lowercase: true
    },
    status: {
        type: String,
        enum: ['available', 'unavailable'],
        default: 'available'
    },
});

const WorkerModel = db.model('worker', workerSchema);

module.exports = WorkerModel;
