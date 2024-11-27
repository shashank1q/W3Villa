const express = require('express');
const controllers = require('../controller/controller');

const databaseRoutes = express.Router();

databaseRoutes.get('/get', controllers.getData);
databaseRoutes.put('/reorder', controllers.reorderTasks);
databaseRoutes.post('/add', controllers.addTask);
databaseRoutes.patch('/edit', controllers.editTask);
databaseRoutes.delete('/delete', controllers.deleteTask);

module.exports = databaseRoutes;