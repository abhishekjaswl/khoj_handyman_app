const WorkerModel = require('../models/worker.model');
const AuthService = require('../services/auth.service');
const otpGenerator = require('otp-generator');


exports.login = async (req, res, next) => {
    try {
        const { email, password } = req.body;

        const user = await AuthService.checkUser(email);

        if (!user) {
            return next('User does not exist.');
        }

        const isMatch = await user.comparePassword(password);
        if (isMatch === false) {
            return next('Invalid Password!');
        }

        const worker = await WorkerModel.findOne({ _id: user._id });

        const userDetails = { ...user.toObject(), ...worker ? worker.toObject() : {} };

        res.status(200).json(userDetails);

    } catch (error) {
        return next(error);
    }
}

exports.register = async (req, res, next) => {
    try {
        const { firstName, lastName, role, email, phone, password } = req.body;

        const existingUser = await AuthService.checkUser(email);
        if (existingUser) {
            return next('User already exists.');
        }
        const user = await AuthService.registerUser(firstName, lastName, role, email, phone, password);

        let worker;
        if (role == 'worker') {
            const workerInstance = new WorkerModel({ _id: user._id });
            worker = await workerInstance.save();
        }
        const userDetails = { ...user.toObject(), ...worker ? worker.toObject() : {} };

        res.status(200).json(userDetails);
    } catch (error) {
        return next(error);
    }
}

exports.checkEmail = async (req, res, next) => {
    try {
        const { email } = req.body;
        const existingUser = await AuthService.checkUser(email);

        if (existingUser) {
            return next('User already exists.');
        }
        res.status(200).json({ existingUser });

    } catch {
        return next(error);
    }
}

exports.getRegisOTP = async (req, res, next) => {
    try {
        const { email, firstName, lastName } = req.body;

        const user = await AuthService.checkUser(email);

        if (user) {
            return next('User already exists!');
        }

        const userName = `${firstName} ${lastName}`;

        const otp = otpGenerator.generate(5, { digits: true, lowerCaseAlphabets: false, upperCaseAlphabets: false, specialChars: false });

        const message = `Thank you for choosing Khoj. Use the following OTP
        to complete the procedure to register to the app. This OTP is
        valid for <span style="font-weight: 600; color: #1f1f1f;">10 minutes</span>.
        Do not share this code with others, including Khoj employees.`

        await AuthService.sendEmail(email, userName, message, otp, 'registration', res, next);

    } catch (error) {
        return next(error);
    }
}

exports.getResetOTP = async (req, res, next) => {
    try {
        const { email } = req.body;

        const user = await AuthService.checkUser(email);

        if (!user) {
            return next('User does not exist.');
        }

        const userName = `${user.firstName} ${user.lastName}`;

        const otp = otpGenerator.generate(5, { digits: true, lowerCaseAlphabets: false, upperCaseAlphabets: false, specialChars: false });

        const message = `Use the following OTP to complete the procedure to 
        reset your password. This OTP is valid for 
        <span style="font-weight: 600; color: #1f1f1f;">10 minutes</span>.
        Do not share this code with others, including Khoj employees.`

        await AuthService.sendEmail(email, userName, message, otp, 'password reset',  res, next);

        res.status(200).json('OTP sent.');

    } catch (error) {
        console.log(error);
        return next(error);
    }
}

exports.verifyOTP = async (req, res, next) => {
    try {
        const email = req.params.email;
        const otp = req.params.otp;
        const purpose = req.params.purpose;
        const verify = await AuthService.checkOTP(email, otp, purpose);

        if (!verify) {
            return next('Incorrect OTP.');
        }
        console.log('otp verified');
        res.status(200).json({ msg: 'OTP verified.' });

    } catch (error) {
        return next(error);
    }
}
