const UserModel = require('../models/user.model');
var nodemailer = require('nodemailer');
const otpGenerator = require('otp-generator');
var Mailgen = require('mailgen');
const otpModel = require('../models/otp.model');

class AuthService {
    static async registerUser(firstName, lastName, dob, role, email, phone, password) {
        try {
            const createUser = new UserModel({ firstName, lastName, dob, role, email, phone, password });
            return await createUser.save();

        } catch (error) {
            throw error;
        }
    }

    static async checkUser(email) {
        try {
            return await UserModel.findOne({ email });
        } catch (error) {
            throw error;
        }
    }

    static async sendOTP(email, purpose, userName, res, next) {
        try {
            const otp = otpGenerator.generate(5, { digits: true, lowerCaseAlphabets: false, upperCaseAlphabets: false, specialChars: false });

            var mailGenerator = new Mailgen({
                theme: 'cerberus',
                product: {
                    // Appears in header & footer of e-mails
                    name: 'KHOJ',
                    link: 'https://mailgen.js/',
                }
            });

            var genEmail = {
                body: {
                    name: userName,
                    intro: [`Here is the OTP to ${purpose}. Do not share this with anyone.`, 'Keep in mind this OTP is only valid for 10 minutes!'],
                    action: {
                        button: {
                            color: '#22BC66',
                            text: otp.split('').join(' '),
                            style: {
                                fontSize: '30px', // Adjust the font size as needed
                            },
                        },
                    },
                    outro: 'Need help, or have questions? Just reply to this email, we\'d love to help.'
                }
            };

            // Generate an HTML email with the provided contents
            var emailBody = mailGenerator.generate(genEmail);

            const transporter = nodemailer.createTransport({
                service: 'gmail',
                auth: {
                    user: 'bookabahun@gmail.com',
                    pass: 'zbeqsldckwqccfsd'
                }
            });

            // Save the OTP in the database
            const otpDocument = new otpModel({
                email: email,
                otp: otp,
                purpose: purpose,
            });

            otpDocument.save()
                .then(() => {

                    var mailOptions = {
                        from: 'bookabahun@gmail.com',
                        to: email,
                        subject: 'Verify your registration.',
                        html: emailBody,
                    };

                    transporter.sendMail(mailOptions, function (error, info) {
                        if (error) {
                            return next(error);
                        }
                        else {
                            res.status(200).json('OTP sent.');
                        }
                    });
                })
                .catch((error) => {
                    // Handle database save error
                    return next('Error saving OTP:', error);
                });

        } catch (error) {
            return next(error);
        }
    }

    static async checkOTP(email, otp, purpose) {
        try {
            return await otpModel.findOne({ email, otp, purpose });
        } catch (error) {
            throw error;
        }
    }
}

module.exports = AuthService;