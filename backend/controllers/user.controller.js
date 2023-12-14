const UserModel = require('../models/user.model');

exports.allUsers = async (req, res, next) => {
    try {
        const allUsers = await UserModel.find();
        res.status(200).json({ allUsers })
    } catch (e) {
        return next(e);
    }
}

exports.uploadProfilePic = async (req, res, next) => {
    try {
        const { id, profilePicUrl } = req.body;

        await UserModel.findOneAndUpdate({ _id: id }, { profilePicUrl: profilePicUrl }, { new: true, runValidators: true })

        res.status(200).json({ msg: 'Profile picture uploaded successfully.' });

    } catch (error) {
        return next(error);
    }
}