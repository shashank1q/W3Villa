const jwt = require('jsonwebtoken');
const crypto = require('crypto');

const key = "sldfhS3#@SFR#"


function createToken(email) {
    try {
        return jwt.sign({ email: email }, key)
    } catch (e) {
        console.log(`Error creating token: ${e.message}`);
        return null;
    }
}

function hashPassword(password) {
    const key = '83jsd72@ef'
    return crypto.createHash('sha256', key).update(password).digest('hex');
}

function verifyToken(token) {
    if (!token) return null;
    try {
        return jwt.verify(token, key);
    } catch (e) {
        console.log(`Error verifying token: ${e.message}`);
        return null;
    }
}

module.exports = {
    createToken, verifyToken, hashPassword
}