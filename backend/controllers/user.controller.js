const UserModel = require('../models/user.model');

exports.allUsers = async (req, res, next) => {
    try {
        const allUsers = await UserModel.find();
        res.status(200).json({ allUsers })
    } catch (e) {
        return next(e);
    }
}