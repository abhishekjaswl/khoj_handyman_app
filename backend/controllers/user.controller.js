const UserModel = require('../models/user.model');
const WorkerModel = require('../models/worker.model');

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
        console.log(dob);
        const user = await UserModel.findOneAndUpdate({ _id: id }, { latitude, longitude, address, dob, gender, status: 'pending' }, { new: true, runValidators: true });
        const worker = await WorkerModel.findOneAndUpdate({ _id: id }, { job }, { new: true, runValidators: true });

        const userDetails = { ...user.toObject(), ...worker ? worker.toObject() : {} };

        res.status(200).json(userDetails);
    } catch (error) {
        console.log(error);
        return next(error);
    }
}

exports.updateAvailability = async (req, res, next) => {
    try {
        const id = req.params.id;
        const availability = req.params.availability;
        const worker = await WorkerModel.findOneAndUpdate({ _id: id }, { availability }, { new: true, runValidators: true });
        res.status(200).json({  worker });
    } catch (error) {
        console.log(error);
        return next(error);
    }
}