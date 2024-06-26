require('dotenv').config();
const UserModel = require('../models/user.model');
var nodemailer = require('nodemailer');
const otpModel = require('../models/otp.model');

class AuthService {
    static async registerUser(firstName, lastName, role, email, phone, password) {
        try {
            const createUser = new UserModel({ firstName, lastName, role, email, phone, password });
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

    static async sendEmail(email, userName, message, otp, purpose, res, next) {
        console.log(otp);
        try {
            var emailBody = `
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <meta http-equiv="X-UA-Compatible" content="ie=edge" />
                <title>Static Template</title>

                <link
                href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap"
                rel="stylesheet"
                />
            </head>
            <body
                style="
                margin: 0;
                font-family: 'Poppins', sans-serif;
                background: #ffffff;
                font-size: 14px;
                "
            >
                <div
                style="
                    max-width: 680px;
                    margin: 0 auto;
                    padding: 45px 30px 60px;
                    background: #f4f7ff;
                    font-size: 14px;
                    color: #434343;
                "
                >
                <header>
                    <table style="width: 100%;">
                    <tbody>
                        <tr style="height: 0;">
                        
                        <td 
                        style="text-align: center ;">
                            <span
                            style="font-size: 30px; line-height: 30px; color: #000000;"
                            >KHOJ</span
                            >
                        </td>
                        </tr>
                    </tbody>
                    </table>
                </header>

                <main>
                    <div
                    style="
                        margin: 0;
                        margin-top: 70px;
                        padding: 92px 30px 115px;
                        background: #ffffff;
                        border-radius: 30px;
                        text-align: center;
                    "
                    >
                    <div style="width: 100%; max-width: 489px; margin: 0 auto;">
                        
                        <p
                        style="
                            margin: 0;
                            margin-top: 17px;
                            font-size: 16px;
                            font-weight: 500;
                        "
                        >
                        Hey ${userName},
                        </p>
                        <p
                        style="
                            margin: 0;
                            margin-top: 17px;
                            font-weight: 500;
                            letter-spacing: 0.56px;
                        ">
                        ${message}
                        </p>
                        
                        
                        ${otp != null ?
                    `<h1 style = "
                            margin: 0;
                            font - size: 24px;
                            font - weight: 500;
                            color: #1f1f1f;
                            "
                        >
                        Your OTP
                        </h1 >
                        <p
                            style="
                            margin: 0;
                            margin-top: 60px;
                            font-size: 40px;
                            font-weight: 600;
                            letter-spacing: 25px;
                            color: #ba3d4f;
                            ">  ${otp} </p>` : ``}
                
                    </div >
                    </div >

                <p
                style="
                        max-width: 400px;
                        margin: 0 auto;
                        margin-top: 90px;
                        text-align: center;
                        font-weight: 500;
                        color: #8c8c8c;
                    "
                >
                Need help? Ask at
                <a
                    href="mailto:khoj@gmail.com"
                    style="color: #499fb6; text-decoration: none;"
                >khoj@gmail.com</a
                >
                or visit our
                <a
                    href=""
                    target="_blank"
                    style="color: #499fb6; text-decoration: none;"
                >Help Center</a
                >
                </p>
                </main >

            <footer
                style="
                    width: 100%;
                    max-width: 490px;
                    margin: 20px auto 0;
                    text-align: center;
                    border-top: 1px solid #e6ebf1;
                    "
                >
                <p
                    style="
                        margin: 0;
                        margin-top: 40px;
                        font-size: 16px;
                        font-weight: 600;
                        color: #434343;
                    "
                >
                    Khoj
                </p>
                <p style="margin: 0; margin-top: 8px; color: #434343;">
                    Kamalpokhari, Kathmandu.
                </p>
                <div style="margin: 0; margin-top: 16px;">
                    <a href="" target="_blank" style="display: inline-block;">
                        <img
                            width="36px"
                            alt="Facebook"
                            src="https://archisketch-resources.s3.ap-northeast-2.amazonaws.com/vrstyler/1661502815169_682499/email-template-icon-facebook"
                        />
                    </a>
                    <a
                        href=""
                        target="_blank"
                        style="display: inline-block; margin-left: 8px;"
                    >
                        <img
                            width="36px"
                            alt="Instagram"
                            src="https://archisketch-resources.s3.ap-northeast-2.amazonaws.com/vrstyler/1661504218208_684135/email-template-icon-instagram"
                        /></a>
                    <a
                        href=""
                        target="_blank"
                        style="display: inline-block; margin-left: 8px;"
                    >
                        <img
                            width="36px"
                            alt="Twitter"
                            src="https://archisketch-resources.s3.ap-northeast-2.amazonaws.com/vrstyler/1661503043040_372004/email-template-icon-twitter"
                        />
                    </a>
                    <a
                        href=""
                        target="_blank"
                        style="display: inline-block; margin-left: 8px;"
                    >
                        <img
                            width="36px"
                            alt="Youtube"
                            src="https://archisketch-resources.s3.ap-northeast-2.amazonaws.com/vrstyler/1661503195931_210869/email-template-icon-youtube"
                        /></a>
                </div>
                <p style="margin: 0; margin-top: 16px; color: #434343;">
                    Copyright © 2024 Company. All rights reserved.
                </p>
            </footer>
                </div >
            </body >
            </html >
            `;

            const transporter = nodemailer.createTransport({
                service: 'gmail',
                auth: {
                    user: process.env.EMAIL,
                    pass: process.env.GOOGLE_KEY
                }
            });

            if (otp != null) {
                // Save the OTP in the database
                const otpDocument = new otpModel({
                    email: email,
                    otp: otp,
                    purpose: purpose,
                });

                otpDocument.save()
                    .then(() => {

                        var mailOptions = {
                            from: process.env.EMAIL,
                            to: email,
                            subject: `Verify your ${purpose}.`,
                            html: emailBody,
                        };

                        transporter.sendMail(mailOptions, function (error, info) {
                            if (error) {
                                console.log(error);
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
            } else {
                var mailOptions = {
                    from: process.env.EMAIL,
                    to: email,
                    subject: purpose,
                    html: emailBody,
                };

                transporter.sendMail(mailOptions, function (error, info) {
                    if (error) {
                        return next(error);
                    }
                    else {
                        res.status(200).json('Email sent.');
                    }
                });
            }


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