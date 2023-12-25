const UserModel = require('../models/user.model');
const WorkerModel = require('../models/worker.model');

exports.allUsers = async (req, res, next) => {
    try {
        const allUsers = await UserModel.find();
        res.status(200).json({ allUsers });
    } catch (e) {
        return next(e);
    }
}

exports.uploadPicture = async (req, res, next) => {
    try {
        const { id, picUrl, purpose } = req.body;

        switch (purpose) {
            case 'Profile Picture':
                await UserModel.findOneAndUpdate({ _id: id }, { profilePicUrl: picUrl }, { new: true, runValidators: true });
                break;
            case 'Citizenship':
                await UserModel.findOneAndUpdate({ _id: id }, { citizenshipUrl: picUrl }, { new: true, runValidators: true });
                break;
            case 'PaymentQR':
                await WorkerModel.findOneAndUpdate({ _id: id }, { paymentQrUrl: picUrl }, { new: true, runValidators: true });
        }
        res.status(200).json(`${purpose} uploaded successfully.`);
    } catch (error) {
        return next(error);
    }
}

exports.uploadKYC = async (req, res, next) => {
    try {
        const id = req.params.id;
        const { latitude, longitude, address, job, dob, gender } = req.body;
        const user = await UserModel.findOneAndUpdate({ _id: id }, { latitude, longitude, address, dob, gender, status: 'pending' }, { new: true, runValidators: true });
        const worker = await WorkerModel.findOneAndUpdate({ _id: id }, { job }, { new: true, runValidators: true });
        res.status(200).json({ user, worker });
    } catch (error) {
        console.log(error);
        return next(error);
    }
}

exports.updateStatus = async (req, res, next) => {
    try {
        const id = req.params.id;
        const status = req.params.status;
        const worker = await WorkerModel.findOneAndUpdate({ _id: id }, { status }, { new: true, runValidators: true });
        res.status(200).json({  worker });
    } catch (error) {
        console.log(error);
        return next(error);
    }
}