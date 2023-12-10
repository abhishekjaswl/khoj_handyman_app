const UserModel = require('../models/user.model');
const jwt = require('jsonwebtoken');

class AuthService {
    static async registerUser(firstName, lastName, email, password, phone, role) {
        try {
            const createUser = new UserModel({ firstName, lastName, email, password, phone, role });
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

    static generateToken = (tokenData) => {
        return jwt.sign({ tokenData }, 'khojsecret', { expiresIn: 7200 });
    }

    static requireAuth = (req, res, next) => {
        const token = req.headers.authorization?.split(' ')[1];

        if (token) {
            jwt.verify(token, 'khojsecret', (err, decodedToken) => {
                if (err) {
                    return res.status(401).send(err);
                }
                else {
                    console.log(decodedToken);
                    next();
                }
            });
        } else {
            return res.status(401).send(err);
        }
    }
}

module.exports = AuthService;