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

        const worker = await WorkerModel.findOne({ _id: user._id })

        const token = AuthService.generateToken(user._id);

        res.status(200).json({ user, worker, token });

    } catch (error) {
        return next(error);
    }
}

exports.register = async (req, res, next) => {
    try {
        const { firstName, lastName, email, password, phone, role } = req.body;

        const existingUser = await AuthService.checkUser(email);

        if (existingUser) {
            return next({ msg: 'User already exists.' });
        }
        const user = await AuthService.registerUser(firstName, lastName, email, password, phone, role);

        if (role == 'worker') {
            const worker = new WorkerModel({ _id: user._id })
            await worker.save();
        }
        res.status(200).json({ user: user._id });
    } catch (error) {
        return next(error);
    }
}

exports.currentUser = async (req, res, next) => {
    const token = req.headers.authorization?.split(' ')[1];

    if (token) {
        jwt.verify(token, 'khojsecret', async (err, decodedToken) => {
            if (err) {
                next();
            }
            else {
                console.log(decodedToken);
                const user = await AuthService.checkUser(email);

                if (!user) {
                    return next({ error: 'User does not exist.' });
                }
                const worker = await WorkerModel.findOne({ _id: user._id })

                res.status(200).json({ user, worker });
            }
        });
    } else {
        return res.status(401).send(err);
    }
}