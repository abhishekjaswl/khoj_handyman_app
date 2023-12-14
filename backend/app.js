const express = require('express');
const body_parser = require('body-parser');
const userRoute = require('./routes/user.route');
const bookingRoute = require('./routes/booking.route');
const authRoute = require('./routes/auth.route');
const errorHandler = require('./utils/errorHandler');

const app = express();
app.use(body_parser.json());

app.use('/api/user', userRoute);
app.use('/api/booking', bookingRoute);
app.use('/api/auth', authRoute);

app.use(errorHandler);

module.exports = app;