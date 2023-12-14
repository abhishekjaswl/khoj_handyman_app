const UserModel = require("../models/user.model");


exports.verifiedWorkerList = async (req, res, next) => {
    try {
        const workers = await UserModel.find({ role: "worker", status: "verified" });

        res.status(200).json(workers);

    } catch (error) {
        return next(error);
    }
}