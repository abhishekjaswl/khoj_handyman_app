const mongoose = require('mongoose');
const db = require('../config/db');
const bcrypt = require('bcrypt');

const { Schema } = mongoose;

const userSchema = new Schema({
    firstName: {
        type: String,
        lowercase: true,
        required: true
    },
    lastName: {
        type: String,
        lowercase: true,
        required: true
    },
    email: {
        type: String,
        lowercase: true,
        required: true,
    },
    password: {
        type: String,
        required: true
    },
    phone: {
        type: Number,
    },
    profilePictureUrl: {
        type: String,
        default: ''
    },
    citizenshipUrl: {
        type: String,
        default: ''
    },
    address: {
        type: String,
        default: ''
    },
    latitude: {
        type: Number,
        default: 0.1
    },
    longitude: {
        type: Number,
        default: 0.1
    },
    status: {
        type: String,
        lowercase: true,
        enum: ['verified', 'unverified'],
        default: 'unverified'
    },
    role: {
        type: String,
        enum: ['user', 'worker', 'admin']
    }
});

userSchema.pre('save', async function () {
    try {
        var user = this;
        const salt = await (bcrypt.genSalt(10));
        const hashpass = await bcrypt.hash(user.password, salt);

        user.password = hashpass;
    } catch (error) {
        throw error;
    }
});

userSchema.methods.comparePassword = async function (userPassword) {
    try {
        const isMatch = await bcrypt.compare(userPassword, this.password);
        return (isMatch);
    } catch (error) {
        throw error;
    }
}

const UserModel = db.model('user', userSchema);

module.exports = UserModel;