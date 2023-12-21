const UserModel = require('../models/user.model');
const WorkerModel = require('../models/worker.model');

exports.allUsers = async (req, res, next) => {
    try {
        const allUsers = await UserModel.find();
        res.status(200).json({ allUsers })
    } catch (e) {
        return next(e);
    }
}

// exports.uploadProfilePic = async (req, res, next) => {
//     try {
//         const { id, profilePicUrl } = req.body;

//         await UserModel.findOneAndUpdate({ _id: id }, { profilePicUrl }, { new: true, runValidators: true })

//         res.status(200).json('Profile picture uploaded successfully.');

//     } catch (error) {
//         return next(error);
//     }
// }

exports.uploadProfilePic = async (req, res, next) => {
    try {
        const { id, picUrl, purpose } = req.body;

        switch (purpose) {
            case 'ProfilePic':
                await UserModel.findOneAndUpdate({ _id: id }, { profilePicUrl: picUrl }, { new: true, runValidators: true });
                break;
            case 'Citizenship':
                await UserModel.findOneAndUpdate({ _id: id }, { citizenshipUrl: picUrl }, { new: true, runValidators: true })
                break;
            case 'PaymentQr':
                await WorkerModel.findOneAndUpdate({ _id: id }, { paymentQrUrl: picUrl }, { new: true, runValidators: true })

        }
        res.status(200).json(`${purpose} uploaded successfully.`);

    } catch (error) {
        return next(error);
    }
}