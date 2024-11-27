const express = require('express');
const cookieParser = require('cookie-parser');
const mongoose = require('mongoose');
const authRoutes = require('./routes/authRoutes');
const databaseRoutes = require('./routes/databaseRoutes');
const cors = require('cors');

// Initialize express
const app = express();

// Middleware
app.use(cors({ credentials: true, origin: "*" }));
app.use(express.json());
app.use(cookieParser());
app.use('/auth', authRoutes);
app.use('/db', databaseRoutes);

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/w3villa').then(() => {
    console.log('Mongodb connected...');
}).catch(err => console.log(`error connecting to mongodb: ${err}`));

// Start the server
app.listen(8000, () => { console.log('Server is running on port 8000') });
