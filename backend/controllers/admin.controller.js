const UserModel = require('../models/user.model');
const WorkerModel = require('../models/worker.model');

exports.allUsers = async (req, res, next) => {
    try {
        const allUsers = await UserModel.find();
        const allWorkers = await WorkerModel.find();

        const userDetails = allUsers.map(user => {
            const workerDetails = allWorkers.find(worker => worker._id.equals(user._id));
            return {
                ...user.toObject(),
                ...(workerDetails ? workerDetails.toObject() : {}),
            };
        });
        res.status(200).json(userDetails);
    } catch (e) {
        return next(e);
    }
}

exports.userList = async (req, res, next) => {
    try {
        const users = await UserModel.find({ role: "user" });

        res.status(200).json(users);

    } catch (error) {
        return next(error);
    }
}

exports.workerList = async (req, res, next) => {
    try {
        const users = await UserModel.find({ role: "worker" });
        const allWorkers = await WorkerModel.find();

        const workerList = users.map(user => {
            const workerDetails = allWorkers.find(worker => worker._id.equals(user._id));
            return {
                ...user.toObject(),
                ...(workerDetails ? workerDetails.toObject() : {}),
            };
        });

        res.status(200).json(workerList);

    } catch (error) {
        return next(error);
    }
}

exports.pendingList = async (req, res, next) => {
    try {
        const pendingUsers = await UserModel.find({ status: "pending" });
        const pendingWorkerDetails = await WorkerModel.find({});

        const pendingList = pendingUsers.map(user => {
            const workerDetails = pendingWorkerDetails.find(worker => worker._id.equals(user._id));
            return {
                ...user.toObject(),
                ...(workerDetails ? workerDetails.toObject() : {}),
            };
        });

        res.status(200).json(pendingList);
    } catch (error) {
        return next(error);
    }
}

exports.updateUserStatus = async (req, res, next) => {
    try {
        const id = req.params.id;
        const status = req.params.status;

        await UserModel.findOneAndUpdate({ _id: id }, { status }, { new: true, runValidators: true });

        res.status(200).json('User ' + status);
    } catch (error) {
        return next(error);
    }
}