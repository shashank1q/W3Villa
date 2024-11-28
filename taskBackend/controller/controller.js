const usermodel = require('../models/user');
const Auth = require('../token/auth');

// Auth controllers
function login(req, res) {
    const body = req.body;
    if (!body.email || !body.password) {
        return res.status(400).send('Invalid request');
    }

    usermodel.findOne({ email: body.email }).then(user => {
        if (!user) {
            return res.status(404).send('User not found');
        }
        if (user.password != Auth.hashPassword(body.password)) {
            return res.status(401).send('Invalid password');
        }
        const newtoken = Auth.createToken(body.email);
        res.cookie('token', newtoken);
        res.status(200).send(newtoken);
    }).catch(err => {
        return res.status(500).send(`Error logging in: ${err}`);
    });
}

function register(req, res) {
    const body = req.body;
    if (!body.email || !body.password) {
        return res.status(400).send('Invalid request');
    }
    usermodel.create({ email: body.email, password: Auth.hashPassword(body.password) }).then(user => {
        const newtoken = Auth.createToken(body.email);
        res.cookie('token', newtoken)
        res.status(200).send(newtoken);
    }).catch(err => {
        return res.status(500).send(`Error registering user: ${err}`);
    });
}

function isValidToken(req, res) {
    // auth token from headers
    const token = req.headers.authorization.split(' ')[1];
    if (token == 'null') {
        return res.status(401).send('no token provided');
    }
    const user = Auth.verifyToken(token);
    if (!user) {
        return res.status(401).send('Invalid token');
    }
    res.status(200).send('Valid token');
}

// Data controllers 
function getData(req, res) {
    const token = req.headers.authorization.split(' ')[1];
    const user = Auth.verifyToken(token);
    if (!user) {
        return res.status(401).send('Invalid token');
    }
    usermodel.findOne({ email: user.email }).then(userdata => {
        res.status(200).send(userdata.data);
    }).catch(err => { return res.status(500).send(`Error fetching data ${err}`); });
}

function reorderTasks(req, res) {
    // recieve list of string in body, store in user.data
    const token = req.headers.authorization.split(' ')[1];
    const user = Auth.verifyToken(token);
    if (!user) {
        return res.status(401).send('Invalid token');
    }
    const list = req.body.data;
    // checks
    if (!Array.isArray(list) || list.some(item => typeof item !== 'string') || list.length === 0) {
        return res.status(400).send('Invalid request');
    }
    // update data
    usermodel.findOneAndUpdate({ email: user.email }, {
        data: list
    }).then(userdata => {
        res.status(200).send('Data updated');
    }).catch(err => {

        return res.status(500).send(`Error updating data: ${err}`);
    });

}

function addTask(req, res) {
    // append one string at the end of the user.data
    const token = req.headers.authorization.split(' ')[1];
    const user = Auth.verifyToken(token);
    if (!user) {
        return res.status(401).send('Invalid token');
    }
    const task = req.body.task;
    // checks
    if (typeof task !== 'string') {
        return res.status(400).send('Invalid request');
    }
    // update data
    usermodel.findOneAndUpdate({ email: user.email }, {
        $push: { data: task }
    }).then(userdata => {
        res.status(200).send('Data updated');
    }).catch(err => {
        return res.status(500).send(`Error adding data: ${err}`);
    })
}

function editTask(req, res) {
    // update one string in the user.data at the given index
    const token = req.headers.authorization.split(' ')[1];
    const user = Auth.verifyToken(token);
    if (!user) {
        return res.status(401).send('Invalid token');
    }
    const index = req.body.index;
    const task = req.body.task;
    // checks
    if (typeof index !== 'number' || typeof task !== 'string') {
        return res.status(400).send('Invalid request');
    }
    // update data
    usermodel.findOne({ email: user.email }).then(userdata => {
        userdata.data[index] = task;
        userdata.save();
        res.status(200).send('Data updated');
    }).catch(err => {
        return res.status(500).send(`Error updating data: ${err}`);

    })

}

function deleteTask(req, res) {
    // delete one string from the user.data at the given index
    const token = req.headers.authorization.split(' ')[1];
    const user = Auth.verifyToken(token);
    if (!user) {
        return res.status(401).send('Invalid token');
    }
    const index = req.body.index;
    // checks
    if (typeof index !== 'number') {
        return res.status(400).send('Invalid request');
    }
    // update data
    usermodel.findOne({ email: user.email }).then(userdata => {
        userdata.data.splice(index, 1);
        userdata.save();
        res.status(200).send('Data updated');
    }).catch(err => {
        return res.status(500).send(`Error deleting data: ${err}`);
    });
}


module.exports = {
    login, register, getData, reorderTasks, addTask, editTask, deleteTask, isValidToken
}