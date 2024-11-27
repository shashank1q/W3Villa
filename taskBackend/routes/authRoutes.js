const express = require('express');
const controllers = require('../controller/controller');

const authRoutes = express.Router();

// login
authRoutes.post('/login', controllers.login);
// register
authRoutes.post('/register', controllers.register);
// isValidToken
authRoutes.get('/isvalid', controllers.isValidToken);

module.exports = authRoutes;