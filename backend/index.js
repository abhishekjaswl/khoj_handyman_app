require('dotenv').config()

// Initialization
const app = require('./app');

// Routes
app.get('/', (req, res) => {
    res.send("This is the Homepage.");
});

// Starting the server in a port
app.listen(process.env.PORT, '0.0.0.0', () => {
    console.log(`Server Started at PORT: ${process.env.PORT}`);
});