const WorkerModel = require('../models/worker.model');
const AuthService = require('../services/auth.service');

exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await AuthService.checkUser(email);

        if (!user) {
            return next({ error: 'User does not exist.' });
        }

        const isMatch = await user.comparePassword(password);
        if (isMatch === false) {
            return next({ error: 'Invalid Password!' });
        }

        const worker = await WorkerModel.findOne({ _id: user._id });

        res.status(200).json({ user, worker });

    } catch (error) {
        return next(error);
    }
}

exports.register = async (req, res, next) => {
    try {
        const { firstName, lastName, dob, role, email, phone, password } = req.body;

        console.log(role);

        const existingUser = await AuthService.checkUser(email);

        if (existingUser) {
            return next({ msg: 'User already exists.' });
        }
        const user = await AuthService.registerUser(firstName, lastName, dob, role, email, phone, password);

        let worker; // Initialize the worker variable

        if (role == 'worker') {
            const workerInstance = new WorkerModel({ _id: user._id });
            worker = await workerInstance.save(); // Save the worker instance and assign it to the variable
        }
        res.status(200).json({ user, worker });
    } catch (error) {
        return next(error);
    }
}

exports.checkEmail = async (req, res, next) => {
    try {
        const { email } = req.body;
        const existingUser = await AuthService.checkUser(email);

        if (existingUser) {
            return next({ msg: 'User already exists.' });
        }
        res.status(200).json({ existingUser });

    } catch {
        return next(error);
    }
}