require('dotenv').config()
const mongoose = require('mongoose');

const connection = mongoose.createConnection(process.env.MONGO_URI).on('open', () => {
    console.log('MongoDb connected.');

}).on('error', () => {
    console.log('MongoDb connection error.');
});

module.exports = connection;